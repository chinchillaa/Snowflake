# 📓 Parquetファイルのクエリと地理空間データの操作

このレッスンでは、Parquet形式のトレイルデータをクエリし、地理空間（GeoSpatial）データを整形・可視化する方法を学びます。

---

## 🥋 Parquetファイルをクエリしてみよう

### 🥋 Parquetデータを確認する

SELECTを実行し、任意の行をクリックしてデータを確認してください。このデータはネスト（入れ子）構造になっていますか？

次に、データをカラムに分解するためのより高度なクエリを作成します。最初の2行分のコードは提供されています。残りは自分で考えてみましょう。

> **続行するには正しい回答が必要です**

**問題:** データにどのような問題がありますか？

**3個選択してください:**

- [ ] Sequenceのスペルが間違っている
- [ ] ElevationとLatitudeが入れ替わっている
- [ ] LatitudeとLongitudeが入れ替わっている
- [ ] Longitudeの値の小数点の位置が想定と異なる（科学的記数法）
- [ ] トレイル名のスペルが間違っている
- [ ] Latitudeの値の小数点の位置が想定と異なる（科学的記数法）

**[送信]**

---

## 🎯 見栄えの良い地理空間カラムを持つビューを作成する

### 🥋 SELECT文を使ってデータの問題を修正する

いくつかのオンラインブログ記事によると、座標の精度をミリメートル単位にするには、小数点以下8桁あれば十分です。

- **緯度（Latitude）** は0（赤道）〜90（極地）の範囲なので、小数点の左側に必要な桁数は最大2桁です
- **経度（Longitude）** は0（本初子午線）〜180の範囲なので、小数点の左側に必要な桁数は最大3桁です

緯度と経度の両方を **NUMBER(11,8)** にキャストすれば安全です。以下がそのSELECT文です。

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

このSELECT文を実行した後、座標の1セットをコピーしてWKT Playgroundサイトに貼り付け、正確かどうか確認できます。Snowflakeにはジオメトリ（Geometry）やジオグラフィ（Geography）データを扱う関数がありますが、地図上にオーバーレイ表示する機能はまだありません。

### 🥋 WKT Playgroundでポイントをテストする

**POINT_ID = 1** の座標を選択し、`POINT()` で囲んでWKT Playgroundに貼り付けます。ズームアウトするのを忘れないでください。

他のポイントもいくつか確認してみてください。クエリに問題がないと確信できたら、その上にビューを作成し、**CHERRY_CREEK_TRAIL** と名付けます。

### 🎯 CHERRY_CREEK_TRAIL というビューを作成する

- SELECT文を **CREATE VIEW** で囲む
- ビュー名は **CHERRY_CREEK_TRAIL** にする
- Melのデータベースの **TRAILS** スキーマに作成する
- 所有者は **SYSADMIN** にする

---

## 🥋 より良いビューに置き換える

### 🥋 || を使って緯度と経度を座標ペアに結合する

WKT Playgroundが求めるフォーマットに合わせて、スペース区切りのペアを作成します。

```sql
select top 100 
 lng||' '||lat as coord_pair
,'POINT('||coord_pair||')' as trail_point
from cherry_creek_trail;
```

**coord_pair** は非常に便利なので、ビューにこのカラムを追加しましょう。カラムを追加するには、ビュー全体を置き換える必要があります。

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

---

## 🥋 LINESTRING を生成できるか？

### 🥋 座標のセットをラインストリングにまとめよう

Snowflakeの **LISTAGG** 関数と新しい **COORD_PAIR** カラムを使って、WKT Playgroundに貼り付けられるLINESTRINGを作成できます。

LINESTRINGの構文を確認しましょう：

| 要素 | 説明 |
|---|---|
| `LINESTRING(` | 開始 |
| 座標ペア | 経度 緯度 |
| `,` | カンマ区切り |
| 座標ペア | 経度 緯度 |
| `)` | 終了 |

### 🥋 このSELECTを実行してWKT Playgroundに結果を貼り付けよう

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

Snowflakeから結果をコピーしてWKT Playgroundに貼り付けると、座標をリストにまとめて作成したLineStringが表示されます。デンバーのConfluence Park上にトレイルの一部が表示されるはずです。

---

## 🎯 トレイル全体を1つのLINESTRINGで生成する

### 🎯 トレイル全体を1本のLINESTRINGにできますか？

FranktownからConfluence Parkまでの1本のLINESTRINGを作成してみましょう。前のSELECT文を使い、制限を「10未満」から「2450未満」に変更してWKT Playgroundに貼り付けてください。

> 2450に制限する理由は、WKT Playgroundが3,500ポイントすべてをプロットしようとするとエラーになるためです。

---

## 🥋 geoJSONファイルを探索する

### 🥋 geoJSONデータを確認する

作成済みのJSONファイルフォーマットを使って、geoJSONステージに対してSELECTを実行します。名前を覚えていない場合は、**SHOW** コマンドで確認してください。

### 🥋 ロードせずにデータを正規化する

```sql
select
$1:features[0]:properties:Name::string as feature_name
,$1:features[0]:geometry:coordinates::string as feature_coordinates
,$1:features[0]:geometry::string as geometry
,$1:features[0]:properties::string as feature_properties
,$1:crs:properties:name::string as specs
,$1 as whole_object
from @trails_geojson (file_format => ff_json);
```

### 🥋 geoJSONデータを視覚的に表示する

Snowflakeではデータの管理や加工はできますが、適切に表示することはできません。WKT形式の地理空間データと同様に、Snowflakeに保存したデータを視覚的に表示するには別のツールが必要です。この演習では [geojson.io](https://geojson.io) を使用します。

---

## 🎯 geoJSONファイル用のビューを作成する

### 🎯 DENVER_AREA_TRAILS というビューを作成する

- 先ほどのSELECT文を **CREATE VIEW** で囲む
- ビュー名は **DENVER_AREA_TRAILS** にする
- Melのデータベースの **TRAILS** スキーマに作成する
- 所有者は **SYSADMIN** にする

---

## ✅ DORA DLKW06

### 🤖 ワークシートでこのコードを実行してDORAにレポートを送信する

> DORAのコードは絶対に編集しないでください。グリーンチェックを得るにはラボの作業を修正してください。

```sql
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
SELECT
'DLKW06' as step
 ,( select count(*) as tally
      from mels_smoothie_challenge_db.information_schema.views 
      where table_name in ('CHERRY_CREEK_TRAIL','DENVER_AREA_TRAILS')) as actual
 ,2 as expected
 ,'Mel\'s views on the geospatial data from Camila' as description
 ); 
```

結果セクションにグリーンチェック ✅ が表示されるはずです。