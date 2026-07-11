# 🥋 マーケットプレイスで地理空間データを探す

## 🥋 OpenStreetMap - スーパーチャージド！

WKT PlaygroundとGeoJSON.ioの両サイトが、データの表示に**OpenStreetMap**を使用していることに気づきましたか？OpenStreetMapはGoogle Mapsのオープンソース代替で、地理空間データ（GeoSpatial Data）の表示に非常に便利です。Melは、OpenStreetMapからすべてのデータを何とか抽出して、自分のSnowflakeアカウントで利用できるようにすべきか検討します。

OpenStreetMapのデータは無料で使用できます。そのため、ラップトップにダウンロードしてクラウドアカウントにアップロードすることは自由です。とはいえ、データのダウンロードと準備には時間がかかる可能性があります。彼はKlausにそのアイデアを話します。

Klausは**OpenStreetMap**のデータが**Snowflakeデータマーケットプレイス**ですでに利用可能であることを教え、**Sonra**という会社がOpenStreetMapのデータを強化してマーケットプレイスで提供していることを確認するようMelに勧めます。Klausは、生データを自分で準備するのに何日もかけるか、数分で必要以上のデータを手に入れるかを選べるとアドバイスします。

> **注意:** 共有をトライアルに追加するには、ロールを**ACCOUNTADMIN**に切り替える必要があります。

サンプルクエリのセットが読み込まれます。興味を引くものがあれば自由に実行してください。

---

## 🥋 Sonraのビューを探索する

### 📓 SonraのDenver Open Street Map（OSM）データについて詳しく学ぶ

- Sonra Denverの共有にはいくつのテーブルがありますか？ビューよりテーブルの方が少ないですか？
- ビューのうち、ビュー名に「SHOP」を含むものはおよそいくつありますか？「AMENITY」を含むものはおよそいくつですか？

---

## 📓 メラニーズ・カフェの場所

### 📓 メラニーズ・カフェの場所を選びましょう

メラニーズ・カフェは実在する場所ではありませんが、Melの計算に使用する場所を選びます。以下からコピー＆ペーストして、これまで使用してきたマッピングツールの1つ以上で選択した場所を確認してください。

| ツール | 値 |
|---|---|
| GOOGLE MAPS | `39.76471253574085, -104.97300245114094` |
| WKT PLAYGROUND | `POINT(-104.9730024511  39.76471253574)` |
| GEOJSON.IO | 角括弧の間に下記を貼り付けてください |

```json
{
  "type": "Feature",
  "properties": {
    "marker-color": "#ee9bdc",
    "marker-size": "medium",
    "marker-symbol": "cafe",
    "name": "Melanie's Cafe"
  },
  "geometry": {
    "type": "Point",
    "coordinates": [
      -104.97300870716572,
      39.76469906695095
    ]
  }
}
```

> **続行するには正しい回答が必要です**

**問題:** 架空のメラニーズ・カフェを、デンバーのどの実在する交差点に配置しましたか？

- [ ] Havana と Hampden
- [ ] Del Mar と 6th Ave
- [ ] Bruce Randolph と Downing
- [ ] Colfax と Speer

**[送信]**

---

## 🥋 変数と定数

### 📓 デンバーのConfluence Park

### 🥋 Snowflakeワークシートでの変数の使用

メラニーの場所とConfluence Parkの座標をそれぞれ変数に設定し、`ST_MAKEPOINT` と `ST_DISTANCE` 関数で距離を計算します。

```sql
set mc_lng='-104.97300245114094';
set mc_lat='39.76471253574085';

set loc_lng='-105.00840763333615';
set loc_lat='39.754141917497826';

select st_makepoint($mc_lng,$mc_lat) as melanies_cafe_point;
select st_makepoint($loc_lng,$loc_lat) as confluent_park_point;

select st_distance(
        st_makepoint($mc_lng,$mc_lat)
        ,st_makepoint($loc_lng,$loc_lat)
        ) as mc_to_cp;
```

> **続行するには正しい回答が必要です**

**問題:** デンバーの実在するConfluence Parkから架空のメラニーズ・カフェまでの距離はどのくらいですか？

- [ ] ~324マイル
- [ ] ~3246チーズバーガー
- [ ] ~3246メートル

**[送信]**

---

### 📓 変数はクールだけど、定数も悪くない！

変数は非常に便利です！コードの一部を書いて、さまざまな状況で使用できるようにする力を与えてくれます。変数に入れるものを変えるだけで、新しい答えが出てきます。

とはいえ、変数の反対である**定数（Constant）** も悪くありません。結局、円は常に360度であり、πは常に3.14から始まります。

したがって、メラニーズ・カフェまでの距離を計算する際に、変数の代わりにその座標に定数を使用することもできます。

---

## 🥋 独自の関数を定義する

### 📓 メラニーズ・カフェまでの距離を測定するUDFを作成しましょう

メラニーズ・カフェは実在する場所ではありませんが、Melのアプリではその架空の場所を基にした計算を大量に行う必要があります。ユーザーである私たちが定義した関数を作成して参照できるようにすることが合理的かもしれません。

ユーザーが関数を定義すると…お察しの通り…**ユーザー定義関数（UDF）** と呼ばれます。

UDFはさまざまな言語で作成できますが、今回はSQLに限定します。

1. Melのデータベースに**LOCATIONS**という2番目のスキーマを作成してください
2. **SYSADMIN**が所有していることを確認してください
3. UDFには**DISTANCE_TO_MC**（Distance to Melanie's Caféの略）という名前を付けます

距離を測定する起点となるポイントを渡す必要があります。それを「location」と呼び、「LOC」と短縮します。**LOC_LAT**を緯度として、**LOC_LNG**を経度として渡します。

```sql
CREATE FUNCTION distance_to_mc(loc_lng number(38,32), loc_lat number(38,32))
  RETURNS FLOAT
  AS
  $$
    <関数コードをここに記述>
  $$
  ;
```

> 関数が**LOCATIONS**スキーマにあり、**SYSADMIN**が所有していることを確認してください。

---

### 🥋 関数コードの記入

距離関数の最初のポイントは、メラニーズ・カフェの架空の場所に基づきます。これは定数です。`?` をどの定数に置き換える必要があるか考えてください。2番目の数値セットは変数として関数に渡されます。距離が返されます。

```sql
CREATE OR REPLACE FUNCTION distance_to_mc(loc_lng number(38,32),loc_lat number(38,32))
  RETURNS FLOAT
  AS
  $$
   st_distance(
        st_makepoint('?','?')
        ,st_makepoint(loc_lng,loc_lat)
        )
  $$
  ;
```

---

### 🥋 新しい関数をテストしましょう！

デンバーの**Tivoli Center**の座標を使って、作成したUDFをテストします。

```sql
set tc_lng='-105.00532059763648';
set tc_lat='39.74548137398218';

select distance_to_mc($tc_lng,$tc_lat);
```

> **続行するには正しい回答が必要です**

**問題:** デンバーの実在するTivoli Centerから架空のメラニーズ・カフェまでの距離はどのくらいですか？

- [ ] ~3.49キロメートル
- [ ] ~3.4マイル
- [ ] ~34イーグルフライト

**[送信]**

---

## 🥋 メラニーの競合を分析する

### 🥋 エリア内の競合ジュースバーのリストを作成する

MelはOSM Wikiを使って、OSMデータでジュースバーを検索する手がかりを得ます。一般的にファストフード（fast_food）として分類されていますが、EzekielTという人が**juice_bar**という新しいアメニティタイプとして分類した方が良いと提案していることがわかります。それまでは、いくつかの食品アメニティカテゴリで検索します（ただし、念のため提案されたタイプも含めます）。

```sql
select *
from OPENSTREETMAP_DENVER.DENVER.V_OSM_DEN_AMENITY_SUSTENANCE
where
    ((amenity in ('fast_food','cafe','restaurant','juice_bar'))
    and
    (name ilike '%jamba%' or name ilike '%juice%'
     or name ilike '%superfruit%'))
 or
    (cuisine like '%smoothie%' or cuisine like '%juice%');
```

- 2022年6月時点では、上記のSELECTで14件のジュースおよびスムージー提供者のリストが得られました
- 2024年6月時点では、SELECTで15件のジュースおよびスムージー提供者が得られました
- Sonraデータはライブであり、時間とともに変動する可能性があります

---

### 🎯 リストをビューに変換する

上記のSELECT文を使って**COMPETITION**というビューを作成してください。

> ビューが**LOCATIONS**スキーマにあり、**SYSADMIN**が所有していることを確認してください。

---

### 🥋 メラニーに最も近い競合はどこか？

`ST_DISTANCE` 関数を使い、メラニーズ・カフェの座標からの距離で競合をソートします。

```sql
SELECT
 name
 ,cuisine
 , ST_DISTANCE(
    st_makepoint('-104.97300245114094','39.76471253574085')
    , coordinates
  ) AS distance_to_melanies
 ,*
FROM  competition
ORDER by distance_to_melanies;
```

---

### 📓 先ほど作成したUDFを使わないのはなぜか？

Sonraのデータは緯度と経度に分離されていないため、私たちの関数を使うのは難しいです。私たちの関数は2つの座標を別々に渡すことを想定していますが、Sonraのデータは各ポイントを**COORDINATES**列に完全なgeoJSON **GEOGRAPHY**オブジェクトとして格納しています。

COORDINATES列を緯度と経度の数値に解析し直すこともできますが、もっと良い方法があります！ — **GEOGRAPHY**オブジェクトをそのまま受け取れる関数が必要です。

---

### 🥋 GEOGRAPHY引数を受け取るように関数を変更する

1つの**GEOGRAPHY**型引数を受け取るバージョンのUDFを作成します。

```sql
CREATE OR REPLACE FUNCTION distance_to_mc(lng_and_lat GEOGRAPHY)
  RETURNS FLOAT
  AS
  $$
   st_distance(
        st_makepoint('-104.97300245114094','39.76471253574085')
        ,lng_and_lat
        )
  $$
  ;
```

### 🥋 Sonraのデータでこれを使用してみましょう

```sql
SELECT
 name
 ,cuisine
 ,distance_to_mc(coordinates) AS distance_to_melanies
 ,*
FROM  competition
ORDER by distance_to_melanies;
```

---

## 📓 同じ名前のUDFが2つあるのはなぜか？

### 📓 一体何が起きているのか？

最初に**DISTANCE_TO_MC**という関数を2つの引数で作成しました。次に、`CREATE OR REPLACE` 文を実行して、**DISTANCE_TO_MC** UDFを1つの引数だけで定義しました。その後はDISTANCE_TO_MCという関数が1つだけ残ると思ったかもしれません。しかし、**LOCATIONS**スキーマのFUNCTIONSを見ると、2つあることがわかります！

コーディングが初めての方は、関数の**オーバーロード（Overloading）** について知らないかもしれません。オーバーロードは悪いことのように聞こえますが、実際にはとてもクールです。

- 同じ関数を異なる方法で実行できることを意味します
- Snowflakeは渡されたものに基づいてUDFのどのバージョンを実行するかを判断します
- 2つの数値を渡すと → 最初のバージョンが実行される
- 1つのGEOGRAPHYポイントを渡すと → 2番目のバージョンが実行される

> 関数とその引数をまとめて**関数シグネチャ（Function Signature）** と呼びます。

---

### 🥋 異なるオプション、同じ結果！

Tattered Cover Bookstore McGregor Squareの座標で、3つの異なる呼び出し方法をテストします。

```sql
set tcb_lng='-104.9956203';
set tcb_lat='39.754874';

select distance_to_mc($tcb_lng,$tcb_lat);

select distance_to_mc(st_makepoint($tcb_lng,$tcb_lat));

select name
, distance_to_mc(coordinates) as distance_to_melanies
, ST_ASWKT(coordinates)
from OPENSTREETMAP_DENVER.DENVER.V_OSM_DEN_SHOP
where shop='books'
and name like '%Tattered Cover%'
and addr_street like '%Wazee%';
```

> **続行するには正しい回答が必要です**

**問題:** 以下の選択肢のうち、関数シグネチャと呼べるものはどれですか？

- [ ] CREATE FUNCTION MY_COOL_FUNCTION
- [ ] RUN MY_COOL FUNCTION()
- [ ] MY_COOL_FUNCTION(x number, y text)
- [ ] SELECT MY_COOL_FUNCTION(2,'Hello')

**[送信]**

---

## 🎯 潜在的なプロモーションパートナーを分析する

### 🎯 デンバーデータの自転車ショップのビューを作成する

Melは、自転車ショップとクロスプロモーションをするのが合理的かもしれないと考えています。最初のステップとして、デンバーデータ内のすべての自転車ショップを見つける必要があります。

デンバーのすべての自転車ショップを**DENVER_BIKE_SHOPS**というビューにまとめてください。

> ビューが**LOCATIONS**スキーマにあり、**SYSADMIN**が所有していることを確認してください。

**ヒント:**

- 現在、データセットには33の自転車ショップがあります（時間とともに変動する可能性がありますが、大幅には変わらないはずです）
- ショップは**V_OSM_DEN_SHOP_OUTDOORS_AND_SPORT_VEHICLES**または**V_OSM_DEN_SHOP**テーブルで見つけることができます。より具体的なビューを使用する利点は、含まれる列が自転車ショップにより直接関連していることです
- `WHERE <column> = 'bicycle'` を使用できます。どの列かを特定する必要があるだけです
- 各自転車ショップについてメラニーズ・カフェまでの距離を計算する**DISTANCE_TO_MELANIES**という列を含めてください

> **続行するには正しい回答が必要です**

**問題:** メラニーズ・カフェから2,490メートル離れている自転車ショップはどれですか？

- [ ] Colorado Cycling Connection
- [ ] The Denver Bicycle Cafe
- [ ] Rino Bike + Snow Repair
- [ ] Chocolate Spokes Studio - Bikes 'n Chocolate
- [ ] CycleBar LoHi
- [ ] The Urban Cyclist

**[送信]**

---

## ✅ DORA DLKW08

### 🤖 ワークシートでこれを実行してDORAにレポートを送信する

> **緑のチェックを取得するためにDORAコードを編集しないでください。ラボの作業を編集してください。**

```sql
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
  SELECT
  'DLKW08' as step
  ,( select truncate(distance_to_melanies)
      from mels_smoothie_challenge_db.locations.denver_bike_shops
      where name like '%Mojo%') as actual
  ,14084 as expected
  ,'Bike Shop View Distance Calc works' as description
 );
```

Snowflakeアカウントの結果セクションに緑のチェック ✅ が表示されるはずです。
