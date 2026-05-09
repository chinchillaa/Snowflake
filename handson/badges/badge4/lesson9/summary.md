# Lesson 9: マテリアライズドビュー、外部テーブル、Icebergテーブル

## 学習目標

マテリアライズドビュー、外部テーブル、Apache Icebergテーブルの3つの高度なオブジェクトを理解し、ロードされていないデータに対して高パフォーマンスなアクセスを実現する方法を学ぶ。それぞれの特性・制約・ユースケースの違いを把握する。

---

## 学んだこと

### 1. マテリアライズドビュー（Materialized View）

**マテリアライズドビュー** は、通常のビューとテーブルの「中間」に位置するオブジェクトです。

**通常のビュー** は保存されたSELECT文にすぎず、クエリのたびにSQLを再実行してデータを取得します。一方、**マテリアライズドビュー** はSELECTの結果を物理的に保存（マテリアライズ＝実体化）し、テーブルのように高速に読み取れます。

| 特性 | 通常のビュー | マテリアライズドビュー |
|---|---|---|
| データの保存 | しない（毎回再計算） | する（結果をキャッシュ） |
| クエリ速度 | 元データの複雑さに依存 | テーブルと同等に高速 |
| 自動更新 | 常に最新（毎回再計算するため） | 基礎データの変更時にSnowflakeが自動リフレッシュ |
| 追加コスト | なし | ストレージ＋自動リフレッシュの計算コスト |

**最適なユースケース:** 集中的なロジック（距離計算など）を持ち、頻繁にクエリされるが、基礎データは滅多に変更されない場合。

> **ステージ上のデータに直接マテリアライズドビューを作成できない理由:** マテリアライズドビューの自動リフレッシュ機能は、基礎となるテーブルの変更を追跡する仕組みに依存しています。ステージ上のファイルはSnowflakeのテーブルではないため、変更追跡の仕組みが適用できず、いつリフレッシュすべきか判断できません。そのため、ステージに直接マテリアライズドビューを配置することはサポートされていません。ただし、間に**外部テーブル**を挟むことで、この制約を回避できます（後述）。

### 2. 外部テーブル（External Table）

**外部テーブル** は、ロードされていないデータ（ステージ上のファイル）の上に配置されるテーブルオブジェクトです。Lesson 6で作成したビューと似ていますが、テーブルとしてSnowflakeに認識されるため、マテリアライズドビューの基盤にできるという大きな違いがあります。

```sql
create or replace external table T_CHERRY_CREEK_TRAIL(
    my_filename varchar(100) as (metadata$filename::varchar(100))
)
location= @trails_parquet
auto_refresh = true
file_format = (type = parquet);
```

**ビューとの構文の違い:**

| 項目 | ビュー | 外部テーブル |
|---|---|---|
| 列定義の順序 | `$1:field::type AS 列名`（定義 → 名前） | `列名 型 AS (定義)`（名前 → 定義） |
| データ変更の検知 | なし | **AUTO_REFRESH** で自動検知可能 |
| マテリアライズドビューの基盤 | なれない | **なれる** |

**なぜ外部テーブルが存在するのか — 組織がデータをロードしない理由:**

- **セキュリティ/ガバナンス:** 規制やポリシーにより、データを別の場所にコピーできない場合がある
- **複数コピーの回避:** 同じデータがS3にもSnowflakeにもあると、同期の問題やストレージコストが発生する
- **ベンダーロックイン回避:** データをSnowflake固有の形式でしか持たないと、将来の移行が困難になる
- **マルチプラットフォーム:** 同じデータをSnowflake以外のシステム（Spark、Prestoなど）からもアクセスしたい

> **外部テーブルの保存場所:** 通常は **AWS S3**、**Azure Blob Storage**、**GCS（Google Cloud Storage）** などのクラウドストレージに置かれます。このワークショップではAWS S3上のファイルを使用しました。

### 3. セキュアマテリアライズドビュー（Secure Materialized View）

ここがこのレッスンの核心です。**外部テーブル → マテリアライズドビュー** の2層構造を使うことで、「ステージ上のデータに直接マテリアライズドビューを配置できない」という制約を回避しつつ、高速なクエリを実現します。

```
ステージ（Parquetファイル）
    ↓ 参照
外部テーブル（T_CHERRY_CREEK_TRAIL）
    ↓ 基盤
セキュアマテリアライズドビュー（SMV_CHERRY_CREEK_TRAIL）
    ↓ クエリ
ユーザー
```

```sql
create secure materialized view SMV_CHERRY_CREEK_TRAIL(
    POINT_ID, TRAIL_NAME, LNG, LAT, COORD_PAIR, DISTANCE_TO_MELANIES
) as
select
 value:sequence_1 as point_id,
 value:trail_name::varchar as trail_name,
 value:latitude::number(11,8) as lng,
 value:longitude::number(11,8) as lat,
 lng||' '||lat as coord_pair,
 locations.distance_to_mc(st_makepoint(lng, lat)) as distance_to_melanies
from t_cherry_creek_trail;
```

> **「セキュア」とは何か:** `SECURE` キーワードを付けると、ビューの定義（SELECT文）が他のユーザーから見えなくなります。共有データに対するセキュリティを高めるために使用されます。

> **なぜこの組み合わせが効果的か:** 3,500ポイントすべてについてメラニーズ・カフェまでの距離を計算する処理は、通常のビューだとクエリのたびに再実行されます。マテリアライズドビューなら結果が保存されるので、2回目以降のクエリは瞬時に返ります。トレイルの座標が変わることはほぼないため、自動リフレッシュが発生するのもまれです。

### 4. Apache Icebergテーブル

**Apache Iceberg** は、Apache Software Foundationが管理するオープンソースのテーブルフォーマットです。Snowflake独自の技術ではなく、業界標準として多くのプラットフォーム（Spark、Flink、Trino等）で利用されています。

**外部テーブルとの最大の違い — データの編集が可能:**

| 操作 | 外部テーブル | Icebergテーブル |
|---|---|---|
| SELECT（読み取り） | できる | できる |
| INSERT（行追加） | **できない** | **できる** |
| UPDATE（行更新） | **できない** | **できる** |
| DELETE（行削除） | **できない** | **できる** |

> **なぜこれが画期的なのか:** 外部テーブルは「読み取り専用の窓」でしかありませんでした。Icebergテーブルは外部ストレージ上のParquetファイルに対して、通常のSnowflakeテーブルと同じようにDML（INSERT/UPDATE/DELETE）を実行できます。データはSnowflakeの外部に残したまま、Snowflakeの使いやすさを維持できます。

### 5. 外部ボリューム（External Volume）の作成

**外部ボリューム** は、Snowflakeの外部にあるクラウドストレージをSnowflakeに登録する仕組みです。Icebergテーブルのデータを保存する場所として使います。

```sql
CREATE OR REPLACE EXTERNAL VOLUME iceberg_external_volume
   STORAGE_LOCATIONS =
      (
         (
            NAME = 'iceberg-s3-us-west-2'
            STORAGE_PROVIDER = 'S3'
            STORAGE_BASE_URL = 's3://uni-dlkw-iceberg'
            STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::321463406630:role/dlkw_iceberg_role'
            STORAGE_AWS_EXTERNAL_ID = 'dlkw_iceberg_id'
         )
      );
```

> **外部ステージとの違い:** 外部ステージは「ファイルの読み込み元」として使いますが、外部ボリュームは「Icebergテーブルのデータ保存先」です。Icebergテーブルがデータを書き込む先として機能するため、読み取りだけでなく書き込みの権限設定（IAMロール）も必要です。

### 6. Icebergテーブルの作成と操作

Icebergテーブル専用のデータベースを作成し、テーブルを定義します:

```sql
create database my_iceberg_db
  catalog = 'SNOWFLAKE'
  external_volume = 'iceberg_external_volume';

create iceberg table identifier($table_name) (
    point_id number(10,0),
    trail_name string,
    coord_pair string,
    distance_to_melanies decimal(20,10),
    user_name string
)
  base_location = $table_name
  as select top 100 ... from SMV_CHERRY_CREEK_TRAIL;
```

> **`catalog = 'SNOWFLAKE'` とは:** Icebergテーブルのメタデータ（どのファイルにどのデータがあるかの管理情報）をSnowflakeが管理することを意味します。他の選択肢として外部カタログ（AWS Glue等）を使うこともできますが、Snowflakeカタログを使うのが最もシンプルです。

作成後は通常のテーブルと同じように操作できます:

```sql
update identifier($table_name)
set user_name = 'I am amazing!!'
where point_id = 1;
```

### 7. データレイクハウス（Data Lakehouse）の進化

データの管理アプローチは時代とともに進化してきました:

| アプローチ | 時代 | 特徴 | 限界 |
|---|---|---|---|
| **データウェアハウス** | 1990年代〜 | 構造化・正規化データの高速分析 | 非構造化データの扱いが苦手、ベンダーロックイン |
| **データレイク** | 2010年代〜 | あらゆる形式のデータを安価に保存 | クエリが遅い、データ品質管理が困難 |
| **データレイクハウス** | 2020年代〜 | 両者の長所を組み合わせ | — |

> **SnowflakeとIcebergの関係:** SnowflakeはIcebergテーブルをサポートすることで、「データレイクハウス」のすべての要素に対応できるようになりました。経営陣にとっては「Snowflakeにロックインされない」安心感があり、開発者にとっては「使い慣れたSQLでそのまま操作できる」利便性があります。

---

## DORA チェック

- **DLKW09**: **SMV_CHERRY_CREEK_TRAIL** の行数が3526であることを検証（外部テーブル → セキュアマテリアライズドビューの連鎖が正しく構成されていることの確認）
