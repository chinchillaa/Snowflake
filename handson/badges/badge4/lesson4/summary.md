# Lesson 4: 非構造化データとカタログ構築

## 学習目標

ディレクトリテーブル、テーブルとビューの結合、CROSS JOINを使い、画像を含むWebカタログを構築する。データレイクハウスの概念を理解する。

---

## 学んだこと

### 1. ディレクトリテーブル (Directory Table)

ステージ内ファイルのメタデータを自動的に提供するテーブル関数:

```sql
select * from directory(@SWEATSUITS);
```

返却カラム: `RELATIVE_PATH`, `FILE_URL`, `LAST_MODIFIED`, `MD5`, `ETAG` 等

### 2. 文字列関数によるファイル名の整形

ファイル名から商品名を生成する段階的な変換:

```sql
select
  replace(relative_path, '_', ' ') as no_under_scores_filename,
  replace(no_under_scores_filename, '.png') as just_words_filename,
  initcap(just_words_filename) as product_name
from directory(@SWEATSUITS);
```

- `REPLACE()` — 文字列の置換
- `INITCAP()` — 各単語の先頭を大文字に変換

### 3. 商品マスタテーブルの作成

ロード済みデータとして `SWEATSUITS` テーブルを作成（10色、価格付き）。

```sql
create table sweatsuits(
    color_or_style varchar(25),
    file_name varchar(50),
    price number(5,2)
);
```

### 4. JOIN: テーブルとディレクトリテーブルの結合

商品テーブルとディレクトリテーブルをJOINし、商品情報と画像URLを紐付け:

```sql
create view product_list as
select initcap(replace(replace(d.relative_path,'_',' '),'.png')) as product_name,
       t.file_name, t.color_or_style, t.price, d.file_url
from sweatsuits t
join directory(@SWEATSUITS) d
  on t.color_or_style = replace(product_name, ' Sweatsuit');
```

### 5. CROSS JOIN: 全組み合わせの生成

商品一覧 × サイズ一覧のクロス結合で全組み合わせのカタログを作成（10商品 × 18サイズ = 180行）:

```sql
create view catalog as
select * from product_list
cross join sweatsuit_sizes;
```

### 6. アップセル対応テーブル

スウェットスーツとスウェットバンドの色マッピングテーブル (`UPSELL_MAPPING`) を作成。

### 7. Webカタログビュー (CATALOG_FOR_WEBSITE)

複数テーブル/ビューを結合した最終的なWebカタログ:

- `CATALOG` (CROSS JOINの結果)
- `UPSELL_MAPPING` (LEFT JOIN)
- `SWEATBAND_COORDINATION` (LEFT JOIN)
- `SWEATBAND_PRODUCT_LINE` (LEFT JOIN)

主な関数:
- `LISTAGG()` — サイズを `|` 区切りで連結
- `COALESCE()` — NULLの場合にデフォルト値を設定
- `GET_PRESIGNED_URL()` — ステージ内画像の一時URLを生成

### 8. データレイクハウス (Data Lakehouse)

ロード済みデータ（テーブル）と非ロードデータ（ステージ上のファイル）を**組み合わせて**活用するアプローチ。

- **ロード済み**: `SWEATSUITS` テーブル, `UPSELL_MAPPING` テーブル
- **非ロード**: ステージ上の画像ファイル、テキストファイルから作ったビュー

---

## DORA チェック

- **DLKW03**: `CATALOG` ビューが180行あることを検証
- **DLKW04**: `CATALOG_FOR_WEBSITE` のアップセル説明が正しいことを検証
