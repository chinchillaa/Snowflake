# Lesson 7: 地理空間関数とトレイルデータの統合

## 学習目標

Snowflakeの地理空間関数を使ってトレイルの長さを計算し、異なるフォーマット（Parquet/geoJSON）のデータを統合して、すべてのトレイルを囲むバウンディングボックスポリゴンを作成する。

---

## 学んだこと

### 1. 地理空間関数（GeoSpatial Functions）の基礎

Snowflakeの地理空間関数の多くは **ST_** というプレフィックスで始まります。これは **Spatial Type（空間型）** の略で、もともとデータベース業界全体で使われてきた命名規約です。

| 関数 | 用途 | 入力 | 出力 |
|---|---|---|---|
| **TO_GEOGRAPHY()** | 文字列をGEOGRAPHYオブジェクトに変換 | WKT文字列やgeoJSON文字列 | GEOGRAPHYオブジェクト |
| **ST_LENGTH()** | LINESTRINGの長さを計算 | GEOGRAPHYオブジェクト | メートル単位の数値 |
| **ST_XMIN()** / **ST_XMAX()** | 経度（東西方向）の最小/最大値を取得 | GEOGRAPHYオブジェクト | 数値（経度） |
| **ST_YMIN()** / **ST_YMAX()** | 緯度（南北方向）の最小/最大値を取得 | GEOGRAPHYオブジェクト | 数値（緯度） |

> **X と Y の覚え方:** 地図を数学の座標平面に見立てると、X軸は横方向（東西＝経度）、Y軸は縦方向（南北＝緯度）です。

### 2. TO_GEOGRAPHY() による型変換 — なぜ必要なのか

Lesson 6で `LISTAGG` を使って `LINESTRING(...)` という文字列を生成しましたが、これはあくまで**ただの文字列（VARCHAR）** です。Snowflakeの地理空間関数（`ST_LENGTH()` 等）は**GEOGRAPHYオブジェクト**を期待するため、文字列をそのまま渡すとエラーになります。

`TO_GEOGRAPHY()` で文字列を地理空間オブジェクトに変換する必要があります:

```sql
select
'LINESTRING('||
listagg(coord_pair, ',')
within group (order by point_id)
||')' as my_linestring
,st_length(to_geography(my_linestring)) as length_of_trail
from cherry_creek_trail
group by trail_name;
```

> **例えるなら:** 「100」という文字列に対して算術演算はできません。数値に変換して初めて計算できます。地理空間データも同様で、文字列 → GEOGRAPHYオブジェクトへの変換が計算の前提条件です。

### 3. ビューへのトレイル長カラムの追加

既存のビューにカラムを追加するには、ビュー全体を `CREATE OR REPLACE VIEW` で再作成する必要があります。Snowflakeのビューには `ALTER VIEW ADD COLUMN` のような構文がないためです。

**GET_DDL()** 関数で既存ビューの定義を取得し、それをベースに編集します:

```sql
select get_ddl('view', 'DENVER_AREA_TRAILS');
```

> **GET_DDL() とは:** 指定したオブジェクト（ビュー、テーブル等）を作成したSQL文を返す関数です。既存の定義をコピーして編集する際にとても便利です。

### 4. 異なるフォーマットのデータ統合

Cherry Creek TrailのデータはParquet形式、他の4つのトレイルはgeoJSON形式です。これらを1つのビューにまとめるには、カラムの形を揃える必要があります。

Parquetデータをg**geoJSON風の文字列に変換**するビュー **DENVER_AREA_TRAILS_2** を作成:

```sql
create or replace view DENVER_AREA_TRAILS_2 as
select
trail_name as feature_name
,'{"coordinates":['||listagg('['||lng||','||lat||']',',') within group (order by point_id)||'],"type":"LineString"}' as geometry
,st_length(to_geography(geometry)) as trail_length
from cherry_creek_trail
group by trail_name;
```

> **なぜParquetをgeoJSON風に変換するのか:** **UNION ALL** で2つのクエリ結果を縦に結合するには、カラムの数とデータ型が一致している必要があります。DENVER_AREA_TRAILS（geoJSON由来）の形に合わせることで、統合が可能になります。

### 5. UNION ALL による結合

**UNION ALL** は2つ以上のSELECT結果を縦に積み重ねる演算子です。

```sql
select feature_name, geometry, trail_length
from DENVER_AREA_TRAILS
union all
select feature_name, geometry, trail_length
from DENVER_AREA_TRAILS_2;
```

| 演算子 | 動作 | 重複行 |
|---|---|---|
| **UNION ALL** | すべての行をそのまま結合 | 残す |
| **UNION** | 結合後に重複を除去 | 除去する |

> **なぜ UNION ではなく UNION ALL なのか:** 今回のデータには重複がないことがわかっているので、重複除去の処理（ソートが必要なため遅い）を省略して **UNION ALL** を使います。不要な処理を省くのはパフォーマンスのベストプラクティスです。

### 6. TRAILS_AND_BOUNDARIES ビューの作成

5つすべてのトレイルについて、東西・南北の最小/最大値を含むビューを作成します。各トレイルの「範囲」がわかるようになり、次のステップ（バウンディングボックス）の基盤になります。

### 7. バウンディングボックスポリゴン（Bounding Box Polygon）

**バウンディングボックス** とは、すべてのトレイルを囲む最小の長方形（矩形）です。「この範囲内にすべてのトレイルが収まる」という外枠を定義します。

```sql
select 'POLYGON(('||
    min(min_eastwest)||' '||max(max_northsouth)||','||
    max(max_eastwest)||' '||max(max_northsouth)||','||
    max(max_eastwest)||' '||min(min_northsouth)||','||
    min(min_eastwest)||' '||min(min_northsouth)||'))' AS my_polygon
from trails_and_boundaries;
```

> **POLYGONの構造:** 4つの角の座標を左上→右上→右下→左下の順に指定します。最初の座標と最後の座標は同じになる（閉じた図形にする）のがWKTのルールです。上記では4点しか指定していませんが、Snowflakeが自動的に閉じてくれます。

### 8. 地理空間データフォーマットの整理

このワークショップで使用した2つのフォーマット:

| フォーマット | 形式 | 代表的なデータ型 | 特徴 |
|---|---|---|---|
| **Well Known Text (WKT)** | テキスト | POINT, LINESTRING, POLYGON | シンプルで人間が読みやすい |
| **GeoJSON** | JSON | Feature, FeatureCollection | Webアプリとの相性が良く、プロパティ（属性）も格納可能 |

---

## DORA チェック

- **DLKW07**: **TRAILS_AND_BOUNDARIES** ビューの `max_northsouth` の最大値を四捨五入した値が40であることを検証（デンバー周辺のトレイルの北端がおよそ北緯40度であることを確認）
