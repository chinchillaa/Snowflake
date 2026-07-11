# Lesson 3: 非ロードデータの活用

## 学習目標

ステージ上のファイルを**テーブルにロードせず**に、ファイルフォーマットとビューを使って直接クエリする手法を学ぶ。

---

## 学んだこと

### 1. ファイルフォーマットの重要性

ステージ上のテキストファイルはそのままでは正しく読めない。ファイルフォーマットオブジェクトを作成し、以下を指定する:

| フォーマット | レコード区切り | フィールド区切り | 用途 |
|---|---|---|---|
| `ZMD_FILE_FORMAT_1` | `;` (セミコロン) | - | サイズ一覧 |
| `ZMD_FILE_FORMAT_2` | `;` (セミコロン) | `\|` (パイプ) | 商品ライン |
| `ZMD_FILE_FORMAT_3` | `^` (キャレット) | `=` (イコール) | コーディネート提案 |

共通設定: `TRIM_SPACE = TRUE`（前後の空白を除去）

### 2. $1, $2 表記でのステージクエリ

ステージ上のファイルには列名がないため `$1`, `$2`, `$3` で列を参照する:

```sql
select $1 from @PRODUCT_METADATA/swt_product_line.txt
  (file_format => ZMD_FILE_FORMAT_2);
```

### 3. データクレンジング

- `REPLACE($1, chr(13)||chr(10))` — CRLF改行コードの除去
- `REPLACE($1, '\r\n')` — 同上（別表記）
- `TRIM_SPACE = TRUE` — 前後空白の除去
- `WHERE sizes_available <> ''` — 空行の除外

### 4. ビューによるデータアクセス

ステージ上のファイルに対してビューを作成し、テーブルと同じようにクエリ可能にする:

| ビュー | 元ファイル | カラム |
|---|---|---|
| `SWEATSUIT_SIZES` | `sweatsuit_sizes.txt` | `sizes_available` |
| `SWEATBAND_PRODUCT_LINE` | `swt_product_line.txt` | `product_code`, `headband_description`, `wristband_description` |
| `SWEATBAND_COORDINATION` | `product_coordination_suggestions.txt` | `product_code`, `has_matching_sweatsuit` |

### 5. 「Leave Data Where It Lands」原則

データをステージにロードしたら、必ずしもテーブルにコピーする必要はない。ビューで直接参照すれば十分なケースがある。

---

## DORA チェック: DLKW02

ビューのデータ品質を検証:
- `SWEATBAND_PRODUCT_LINE` の `product_code` が7文字以下であること
- `SWEATSUIT_SIZES` の先頭2文字がCRLFでないこと
