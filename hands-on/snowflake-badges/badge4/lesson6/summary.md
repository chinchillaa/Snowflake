# Lesson 6: Parquetファイルのクエリと地理空間データの可視化

## 学習目標

Parquet形式のトレイルデータをクエリし、データの問題を修正してビューを作成する。geoJSONデータを探索し、外部ツールで地理空間データを可視化する方法を学ぶ。

---

## 学んだこと

### 1. Parquetファイルのカラム展開

**Parquet** はカラム（列）指向のバイナリ形式です。CSVのように人間が直接読めるテキストではありませんが、圧縮効率が高く、大量データの処理に優れています。

Snowflakeでは `$1:カラム名` という記法でParquetファイル内のネスト構造を個別カラムに展開できます。`$1` はファイル内の各行（レコード）を表し、`:` の後にフィールド名を指定します。

```sql
select
 $1:sequence_1 as point_id,
 $1:trail_name::varchar as trail_name,
 $1:latitude::number(11,8) as lng,
 $1:longitude::number(11,8) as lat
from @trails_parquet
(file_format => ff_parquet)
order by point_id;
```

> **`::varchar` や `::number(11,8)` とは:** Snowflakeの**型キャスト**構文です。ステージ上のファイルから取得したデータはデフォルトで **VARIANT** 型（何でも入る汎用型）になるため、明示的に型を指定して変換する必要があります。

### 2. データの問題の発見と修正

実際のデータは完璧とは限りません。このParquetファイルには以下の問題がありました:

| 問題 | 詳細 | 影響 |
|---|---|---|
| **緯度と経度が入れ替わっている** | `latitude` フィールドに経度の値が入っている | 地図上でまったく違う場所に表示される |
| **値が科学的記数法** | 例: `-1.0497E+02` と表示される | 人間が読みにくく、精度の確認が困難 |

**修正方法:** `NUMBER(11,8)` にキャストすることで解決します。

- `11` = 合計桁数（整数部 + 小数部）
- `8` = 小数点以下の桁数（ミリメートル精度）
- 経度は最大180なので整数部3桁、緯度は最大90なので整数部2桁 → `NUMBER(11,8)` なら両方に対応可能

> **なぜ小数点以下8桁なのか:** 地理座標の精度は桁数で決まります。小数点以下6桁で約11cm、8桁なら約1mmの精度です。トレイルデータには8桁あれば十分すぎるほどの精度があります。

### 3. CHERRY_CREEK_TRAIL ビューの作成

ステージ上のParquetデータに対する**ビュー（View）** を作成します。ビューは「保存されたSELECT文」のようなもので、実行するたびにステージ上のファイルから最新データを取得します。

```sql
create or replace view cherry_creek_trail as
select
 $1:sequence_1 as point_id,
 $1:trail_name::varchar as trail_name,
 $1:latitude::number(11,8) as lng,
 $1:longitude::number(11,8) as lat,
 lng||' '||lat as coord_pair
from @trails_parquet
(file_format => ff_parquet)
order by point_id;
```

> **`||` 演算子とは:** 文字列の**連結演算子**です。`lng||' '||lat` は「経度 + スペース + 緯度」を1つの文字列にまとめます。後のレッスンでWKT形式のLINESTRINGを生成する際に、この **coord_pair** カラムが非常に便利になります。

> **なぜビューを使うのか:** テーブルにロードする代わりにビューを使うことで、データのコピーを作らずに済みます。元のParquetファイルが更新されれば、ビューの結果も自動的に変わります。ただし、クエリのたびにファイルを読み込むため、大量データではパフォーマンスが劣ります。

### 4. LINESTRING の生成

**LINESTRING** とは、複数の座標ポイントを順に結んだ線を表すWKT形式のデータ型です。トレイルのような「道筋」を表現するのに使います。

**LISTAGG** 関数を使って、複数行の座標ペアを1つの長い文字列に連結します:

```sql
select
'LINESTRING('||
listagg(coord_pair, ',')
within group (order by point_id)
||')' as my_linestring
from cherry_creek_trail
where point_id <= 10
group by trail_name;
```

| 要素 | 役割 |
|---|---|
| **LISTAGG(coord_pair, ',')** | 複数行のcoord_pairをカンマ区切りで1つの文字列に連結する集約関数 |
| **WITHIN GROUP (ORDER BY point_id)** | 連結する順序を指定（ポイント順に並べないとトレイルの形がおかしくなる） |
| **GROUP BY trail_name** | トレイルごとにグループ化 |

> **なぜ最初は10ポイントだけにするのか:** WKT Playgroundに貼り付けて動作確認するためです。3,500ポイントすべてを一度に渡すとエラーになることがあるため、まず少量でテストしてから全体に適用するのがベストプラクティスです。

### 5. geoJSONデータの探索

**geoJSON** はJSON形式で地理空間データを表現する標準フォーマットです。Parquetと異なり、人間が読めるテキスト形式で、Webアプリケーションとの相性が良いのが特徴です。

JSONファイルフォーマットを使ってgeoJSONステージのデータを正規化（フラット化）します:

```sql
select
$1:features[0]:properties:Name::string as feature_name
,$1:features[0]:geometry:coordinates::string as feature_coordinates
,$1:features[0]:geometry::string as geometry
from @trails_geojson (file_format => ff_json);
```

> **`$1:features[0]:properties:Name` の読み方:** `$1` = 行全体、`:features` = featuresキー、`[0]` = 配列の最初の要素、`:properties:Name` = ネストされたキーの値。JSONの深い階層に直接アクセスするSnowflakeの強力な記法です。

### 6. DENVER_AREA_TRAILS ビューの作成

geoJSONステージ上のデータに対するビューを作成し、**TRAILS** スキーマに配置します。これで、Lesson 5で作成した環境に2つのビューが揃います:

| ビュー名 | データソース | 内容 |
|---|---|---|
| **CHERRY_CREEK_TRAIL** | Parquetファイル | Cherry Creekトレイルの3,500+座標ポイント |
| **DENVER_AREA_TRAILS** | geoJSONファイル | デンバー周辺の4つのトレイル経路 |

### 7. 地理空間データの可視化ツール

Snowflakeは強力なデータ処理エンジンですが、地理空間データを地図上に表示する機能は（本レッスン時点では）持っていません。そのため、外部の可視化ツールを使います:

| ツール | 対応フォーマット | 用途 |
|---|---|---|
| **WKT Playground** | WKT形式（POINT, LINESTRING, POLYGON） | Snowflakeで生成したWKT文字列を貼り付けて地図上に表示 |
| **geojson.io** | geoJSON形式 | geoJSONデータを貼り付けて地図上に表示・編集 |

> **なぜ外部ツールが必要なのか:** Snowflakeはデータの保存・加工・分析に特化したプラットフォームです。可視化にはStreamlit in SnowflakeやサードパーティのBIツールを組み合わせるのが一般的です。

---

## DORA チェック

- **DLKW06**: **CHERRY_CREEK_TRAIL** と **DENVER_AREA_TRAILS** の2つのビューが **TRAILS** スキーマに存在することを検証
