# Lesson 8: マーケットプレイスデータ、UDF、競合分析

## 学習目標

Snowflakeマーケットプレイスからサードパーティデータを取得し、ユーザー定義関数（UDF）を作成して距離計算を再利用可能にする。競合店舗や潜在的パートナーの分析を通じて、データ活用の実践的なパターンを学ぶ。

---

## 学んだこと

### 1. Snowflakeデータマーケットプレイス

**Snowflakeマーケットプレイス** は、サードパーティのデータプロバイダーが公開するデータセットを自分のSnowflakeアカウントに追加できる仕組みです。データのダウンロードやETLは不要で、共有（Share）を通じて即座にアクセスできます。

このレッスンでは **Sonra** 社が提供する **OpenStreetMap** のデンバー地域データを取得しました。

| 方法 | 所要時間 | 手間 |
|---|---|---|
| 自分でOpenStreetMapデータをダウンロード・変換 | 数日 | ダウンロード、パース、クリーニング、ロード |
| マーケットプレイスから共有を追加 | 数分 | ボタンをクリックするだけ |

> **なぜACCOUNTADMINが必要なのか:** マーケットプレイスの共有を追加するとアカウントに新しいデータベースが作成されます。これはアカウントレベルの操作なので、**ACCOUNTADMIN** ロールの権限が必要です。

### 2. LOCATIONSスキーマの作成

**MELS_SMOOTHIE_CHALLENGE_DB** に2番目のスキーマ **LOCATIONS** を追加しました。

> **なぜスキーマを分けるのか:** **TRAILS** スキーマにはトレイルデータ、**LOCATIONS** スキーマには場所・距離関連のデータを格納します。スキーマを分けることで、データの目的や責任範囲が明確になり、権限管理もしやすくなります。**SYSADMIN** が所有します。

### 3. Snowflakeの変数と定数

**変数** は `SET` 文で定義し、`$変数名` で参照します。同じ計算を異なる場所に対して実行したいとき、座標の値だけを変えれば済むので便利です。

```sql
set mc_lng='-104.97300245114094';
set mc_lat='39.76471253574085';

select st_distance(
    st_makepoint($mc_lng,$mc_lat),
    st_makepoint($loc_lng,$loc_lat)
) as mc_to_cp;
```

一方、**定数** は値が変わらないものです。メラニーズ・カフェの座標は常に同じなので、UDFの中では定数として埋め込みます。

| 関数 | 役割 |
|---|---|
| **ST_MAKEPOINT(経度, 緯度)** | 経度・緯度の数値からGEOGRAPHYポイントオブジェクトを作成 |
| **ST_DISTANCE(ポイントA, ポイントB)** | 2つの地理空間ポイント間の距離を**メートル単位**で返す |

> **なぜメートル単位なのか:** Snowflakeの地理空間関数はデフォルトで**WGS 84**座標系を使用し、距離はメートルで返します。マイルやキロメートルに変換したい場合は、自分で割り算をする必要があります（1km = 1000m、1マイル ≈ 1609m）。

### 4. ユーザー定義関数（UDF）

**UDF（User Defined Function）** は、よく使うロジックを関数として定義し、名前を付けて再利用可能にする仕組みです。同じ計算を何度も書く代わりに、関数を呼び出すだけで済みます。

**バージョン1: 数値引数（経度・緯度を個別に渡す）**

```sql
CREATE OR REPLACE FUNCTION distance_to_mc(loc_lng number(38,32), loc_lat number(38,32))
  RETURNS FLOAT
  AS
  $$
   st_distance(
        st_makepoint('-104.97300245114094','39.76471253574085'),
        st_makepoint(loc_lng, loc_lat))
  $$;
```

**バージョン2: GEOGRAPHY引数（GEOGRAPHYオブジェクトを直接渡す）**

```sql
CREATE OR REPLACE FUNCTION distance_to_mc(lng_and_lat GEOGRAPHY)
  RETURNS FLOAT
  AS
  $$
   st_distance(
        st_makepoint('-104.97300245114094','39.76471253574085'),
        lng_and_lat)
  $$;
```

> **なぜ2つのバージョンが必要なのか:** データソースによって座標の持ち方が異なります。自分で作ったデータは経度・緯度が別々のカラムですが、Sonraのデータは**COORDINATES**カラムに1つのGEOGRAPHYオブジェクトとして格納されています。どちらのケースにも対応できるように、引数の型が異なる2つのバージョンを用意します。

### 5. 関数のオーバーロード（Overloading）

**オーバーロード** とは、同じ名前の関数を異なる引数の型で複数定義できる仕組みです。

- `CREATE OR REPLACE` しても、引数の型が異なれば**別の関数として共存**します
- Snowflakeは呼び出し時に渡された引数の型を見て、適切なバージョンを自動選択します
- 関数名 + 引数の型の組み合わせを**関数シグネチャ（Function Signature）** と呼びます

| 呼び出し方 | 使われるバージョン |
|---|---|
| `distance_to_mc(-105.00, 39.75)` | バージョン1（2つの数値） |
| `distance_to_mc(st_makepoint(-105.00, 39.75))` | バージョン2（GEOGRAPHYオブジェクト） |
| `distance_to_mc(coordinates)` | バージョン2（GEOGRAPHYカラム） |

> **オーバーロードのメリット:** 関数を呼ぶ側は引数の型を気にせず同じ関数名を使えるので、コードが読みやすくなります。プログラミング言語（Java、C++等）でも広く使われている概念です。

### 6. 競合分析: COMPETITIONビュー

Sonraの **V_OSM_DEN_AMENITY_SUSTENANCE** ビューから、メラニーズ・カフェの競合となりうるジュース/スムージー提供者を抽出してビュー化しました:

```sql
create or replace view COMPETITION as
select *
from OPENSTREETMAP_DENVER.DENVER.V_OSM_DEN_AMENITY_SUSTENANCE
where (amenity in ('fast_food','cafe','restaurant','juice_bar'))
  and (name ilike '%jamba%' or name ilike '%juice%' or name ilike '%superfruit%')
  or (cuisine like '%smoothie%' or cuisine like '%juice%');
```

> **`ILIKE` vs `LIKE` の違い:** `LIKE` は大文字・小文字を区別しますが、`ILIKE` は区別しません。実際のデータでは店名の大文字小文字が統一されていないことが多いため、`ILIKE` を使うとより多くの結果を拾えます。

### 7. パートナー分析: DENVER_BIKE_SHOPSビュー

Melは自転車ショップとのクロスプロモーションを検討しています。**V_OSM_DEN_SHOP_OUTDOORS_AND_SPORT_VEHICLES** から自転車ショップを抽出し、UDFで各ショップからメラニーズ・カフェまでの距離を計算する **DISTANCE_TO_MELANIES** カラムを含めたビューを作成します。

> **なぜ距離を計算するのか:** 近くの自転車ショップほどプロモーション提携の効果が高いと考えられるため、距離順でソートして優先順位を付けることができます。

---

## DORA チェック

- **DLKW08**: **DENVER_BIKE_SHOPS** ビューで「Mojo」を含むショップの `distance_to_melanies` を `TRUNCATE` した値が14084であることを検証（UDFの計算が正しく動作していることの確認）
