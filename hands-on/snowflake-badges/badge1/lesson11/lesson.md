# 🎭 半構造化データフォーマット（Semi-Structured Data Formats）

---

# 🎯 JSONテーブルとファイルフォーマットの作成、ファイルのロード

## 🎯 JSONファイルをダウンロードする

> **author_with_header.json** (550 B)

## 🎯 ダウンロードしたJSONファイルを確認する

著者レコードを囲む**角括弧**（square bracket）に注目してください。この角括弧があると、すべてのデータが1つの行にまとめられてしまう可能性があります。この問題を解決する設定に注意してください。

---

## 🥋 生のJSONデータ用テーブルを作成する

```sql
use database library_card_catalog;
use role sysadmin;

create table library_card_catalog.public.author_ingest_json
(
  raw_author variant
);
```

---

## 🎯 JSONデータをロードするためのファイルフォーマットを作成する

以下のコードをワークシートに貼り付けた後、`<?>` を **TRUE** または **FALSE** に置き換えてください。各設定のデフォルト値は **FALSE** です。ファイルデータを個別の行にロードするには、いずれか1つの値を **TRUE** に設定する必要があります。TRUE と FALSE の周りに**クォートを使わないでください**。これらはブーリアン値であり、文字列ではありません。

```sql
create file format library_card_catalog.public.json_file_format
type = 'JSON' 
compression = 'AUTO' 
enable_octal = <?>
allow_duplicate = <?> 
strip_outer_array = <?>
strip_null_values = <?> 
ignore_utf8_errors = <?>; 
```

---

## 🎯 作成したファイルフォーマットを使って新しいテーブルにデータをロードする

次のステップはかなりチャレンジングですが、ここまで学んだことを総合的に活用する練習になります。これはSnowflakeユーザーが実際の仕事で行う作業に非常に近いものです。

ロード前にファイルフォーマットをテストするには、そのファイルフォーマットを使ってファイルをクエリします（レッスン9のチャレンジラボで行った方法です）。

結果が気に入らない場合は、ファイルフォーマットを修正してください（カラムは1つだけですが、行は複数あるべきです）。

ファイルフォーマットに満足したら、COPY INTO文を作成してください。

COPY INTO文には以下が必要です：

- ステージされたファイル（ファイル名は上記、ステージ名は下記）
- ファイルフォーマット（作成済み）
- ロード先のテーブル（作成済み）

> 構文のリマインダーが必要な場合: https://docs.snowflake.com/en/sql-reference/sql/copy-into-table

> ステージを覚えていますか？ `@util_db.public.my_internal_stage` です。

---

> **続行するには正しい回答が必要です**

**問題:** **TRUE** に設定すると、角括弧を無視して各著者を別々の行にロードできるファイルフォーマットプロパティはどれですか？

- [ ] ENABLE_OCTAL
- [ ] ALLOW_DUPLICATE
- [ ] STRIP_OUTER_ARRAY
- [ ] STRIP_NULL_VALUES
- [ ] IGNORE_UTF8_ERRORS

**[送信]**

---

# 🎯 JSON行を確認する

## 🥋 JSONデータをクエリする

```sql
select raw_author:AUTHOR_UID
from author_ingest_json;

SELECT 
 raw_author:AUTHOR_UID
,raw_author:FIRST_NAME::STRING as FIRST_NAME
,raw_author:MIDDLE_NAME::STRING as MIDDLE_NAME
,raw_author:LAST_NAME::STRING as LAST_NAME
FROM AUTHOR_INGEST_JSON;
```

最初のクエリは、トップレベルオブジェクトの属性から **AUTHOR_UID** の値を返します。

2番目のクエリは、正規化されたテーブルのように見える形でデータを返します。

---

# 🤖 DORA DWW16

> ⚠️ **DORAコードは絶対に編集しないでください。** グリーンチェックを得るためにDORAコードを変更するのではなく、ラボ作業を修正してください。

```sql
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
  SELECT 'DWW16' as step
  ,( select row_count 
    from LIBRARY_CARD_CATALOG.INFORMATION_SCHEMA.TABLES 
    where table_name = 'AUTHOR_INGEST_JSON') as actual
  ,6 as expected
  ,'Check number of rows' as description
 ); 
```
