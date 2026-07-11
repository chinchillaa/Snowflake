# 🥋 地理空間関数（GeoSpatial Functions）を探索する

## 📓 Snowflakeで利用可能な地理空間関数を調べる

docs.snowflake.com にアクセスし、「GeoSpatial Functions」を検索してください。関数のリストが表示されるはずです。

多くの関数が **ST_** で始まることに気づきましたか？これは**Spatial Type（空間型）** の略で、もともと**GEOMETRY**データ型での使用を目的に開発されたものです。Snowflakeの**GEOGRAPHY**データオブジェクトをサポートするためにSnowflakeに追加されました。

---

## 🥋 以前のコードを再利用する（少し追加あり）

以前のコードを覚えていますか？`st_length` を使ってトレイルの長さを計算する行を追加しますが、このままではエラーになります。

```sql
select
'LINESTRING('||
listagg(coord_pair, ',')
within group (order by point_id)
||')' as my_linestring
,st_length(my_linestring) as length_of_trail
from cherry_creek_trail
group by trail_name;
```

WKT Playgroundは文字列（地理空間オブジェクトのように見えるもの）を地理空間オブジェクトに変換して表示してくれました。しかしSnowflakeでは自分で変換する必要があります。簡単です！**TO_GEOGRAPHY()** 関数を使えばOKです！

---

## 🎯 TO_GEOGRAPHY チャレンジラボ！

上記のクエリに **TO_GEOGRAPHY()** 関数を追加して、`length_of_trail` 列が正しく動作し、エラーが出なくなるようにしてください。

> **ヒント:** LINESTRINGの長さを計算するには、データがLINESTRINGでなければなりません。LINESTRINGのように見えるだけの座標リスト（実際にはただの文字列）ではダメです。

関数の連携方法を確認したら、同じパターンをもう1つのビュー — **DENVER_AREA_TRAILS**ビューに適用します。

---

## 🎯 ビューにトレイルの長さを追加する

### 🎯 他のトレイルの長さを計算する

Snowflakeの地理空間関数を使って、**DENVER_AREA_TRAILS**ビューで利用可能なトレイルの長さを導出してください。

1. まずSELECT文でコードをテストする
2. コードができたら、ビュー定義に追加する

---

### 🎯 DENVER_AREA_TRAILSビューにLength列を追加する

開発したコードを使って、ビューに長さ列を追加できます。元のビューを置き換えますが、列を追加します。

既存のビューの `CREATE OR REPLACE VIEW` コードブロックを取得するには、以下のコードを実行します：

```sql
select get_ddl('view', 'DENVER_AREA_TRAILS');
```

または、メニューからビュー定義を取得することもできます。

ビュー定義をワークシートに貼り付けて編集してください。

---

## 🥋 トレイルデータを統合する

### 📓 トレイルを1つにまとめる

ここまでたくさんのクールなことをやってきましたが、データはまだ一切ロードしていないことを思い出してください！

データは着地した場所にそのまま残しています（Camilaがフィットネストラッキングウォッチからダウンロードした時のまま）。そして、ファイルフォーマットとビューを使ってクエリに構造を重ねてきました。これが素晴らしいデータエンジニアリング手法だと言っているわけではありません — **データを着地した場所に残す（Leave-it-where-it-lands）** ツールボックスのすべてのツールを教えています。

少しやっつけ仕事に感じることもありますか？はい！でもプロジェクトチーム、設定、納期によっては、これらのノーロードツールが間違ったタスクに貴重な時間を費やすことを防いでくれるかもしれません。

では、**CHERRY_CREEK_TRAIL**と**DENVER_AREA_TRAILS**のデータを十分に似た形にして、5つすべてのトレイルに対して地理空間関数を一度に実行できるようにしましょう！

---

### 🥋 Cherry Creekデータに他のトレイルデータを模倣するビューを作成する

Parquetから始まったデータをgeoJSONデータと結合しますが、geoJSONのように見えるようにします。

```sql
create or replace view DENVER_AREA_TRAILS_2 as
select
trail_name as feature_name
,'{"coordinates":['||listagg('['||lng||','||lat||']',',') within group (order by point_id)||'],"type":"LineString"}' as geometry
,st_length(to_geography(geometry))  as trail_length
from cherry_creek_trail
group by trail_name;
```

---

### 🥋 UNION ALLを使って行を1つの結果セットにまとめる

```sql
select feature_name, geometry, trail_length
from DENVER_AREA_TRAILS
union all
select feature_name, geometry, trail_length
from DENVER_AREA_TRAILS_2;
```

> **続行するには正しい回答が必要です**

**問題:** このワークショップでこれまでに使用した地理空間データフォーマットは何ですか？

- [ ] Well Known Text (WKT)
- [ ] Keyhole Markup Language (KML)
- [ ] GeoJSON
- [ ] Well Known Binary (WKB)

**[送信]**

---

## 🥋 地理空間トレイルビューを強化する

### 📓 5つすべてのトレイルの地理空間LineStringが同じビューに入りました

さまざまなトレイルの長さを比較することもできます（メートル単位で表示されます。チーズバーガー単位ではありません）。

---

### 🥋 まだまだあります！

より多くの地理空間計算を追加して、より詳細な地理空間情報を取得します。

```sql
select feature_name
, to_geography(geometry) as my_linestring
, st_xmin(my_linestring) as min_eastwest
, st_xmax(my_linestring) as max_eastwest
, st_ymin(my_linestring) as min_northsouth
, st_ymax(my_linestring) as max_northsouth
, trail_length
from DENVER_AREA_TRAILS
union all
select feature_name
, to_geography(geometry) as my_linestring
, st_xmin(my_linestring) as min_eastwest
, st_xmax(my_linestring) as max_eastwest
, st_ymin(my_linestring) as min_northsouth
, st_ymax(my_linestring) as max_northsouth
, trail_length
from DENVER_AREA_TRAILS_2;
```

---

### 🥋 ビューにしましょう

> **続行するには正しい回答が必要です**

**問題:** このワークショップでこれまでに使用した地理空間データ関数は何ですか？

**4個選択してください:**

- [ ] TO_GEOGRAPHY()
- [ ] ST_LENGTH()
- [ ] ST_XMIN()
- [ ] ST_YMAX()
- [ ] STDDEV

**[送信]**

---

## 🥋 バウンディングボックスポリゴンを作成する

### 📓 ポリゴンを使ってバウンディングボックス（Bounding Box）を作成できる

すべてのトレイルの最小・最大の東西・南北の値を使って、トレイル全体を囲む**ポリゴン**を作成します。

```sql
select 'POLYGON(('||
    min(min_eastwest)||' '||max(max_northsouth)||','||
    max(max_eastwest)||' '||max(max_northsouth)||','||
    max(max_eastwest)||' '||min(min_northsouth)||','||
    min(min_eastwest)||' '||min(min_northsouth)||'))' AS my_polygon
from trails_and_boundaries;
```

---

## ✅ DORA DLKW07

### 🤖 ワークシートでこれを実行してDORAにレポートを送信する

> **緑のチェックを取得するためにDORAコードを編集しないでください。ラボの作業を編集してください。**

```sql
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
 SELECT
  'DLKW07' as step
   ,( select round(max(max_northsouth))
      from MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.TRAILS_AND_BOUNDARIES)
      as actual
 ,40 as expected
 ,'Trails Northern Extent' as description
 );
```

Snowflakeアカウントの結果セクションに緑のチェック ✅ が表示されるはずです。
