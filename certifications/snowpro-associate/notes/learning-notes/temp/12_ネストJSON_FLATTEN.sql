-- ============================================================
-- 12_ネストJSON_FLATTEN.sql
-- Snowflake DWW Badge 1 - FLATTEN による配列の展開
-- ============================================================
-- 【概要】
-- JSON の配列（authors: [{...}, {...}]）はそのままでは1セルに収まる。
-- FLATTEN 関数を使うと配列の各要素を「横」ではなく「縦」に展開し、
-- 通常のテーブル行のように扱えるようになる。
--
-- FLATTEN の2つの書き方：
--   1. LATERAL FLATTEN(input => json_path)
--   2. TABLE(FLATTEN(json_path))
--   どちらも同じ結果を返す（表記スタイルの違いのみ）
--
-- LATERAL（ラテラル）とは：
--   同じ FROM 句内の他のテーブル・関数の結果を参照できる結合方法。
--   「横方向に連動する」イメージ。
-- ============================================================


-- ============================================================
-- 1. FLATTEN の基本（著者名を展開）
-- ============================================================
-- 【目的】ネストした authors 配列から著者の first_name を1行ずつ取り出す
-- 【動作】LATERAL FLATTEN が配列の各要素を1行に展開し、
-- 　　　  value という列名で各要素にアクセスできるようになる

-- use these example flatten commands to explore flattening the nested book and author data

-- 書き方①: LATERAL FLATTEN
select value:first_name
from nested_ingest_json
,lateral flatten(input => raw_nested_book:authors);
-- 「, lateral flatten(...)」はクロス結合のような働きをする

-- 書き方②: TABLE(FLATTEN)（①と結果は同じ）
select value:first_name
from nested_ingest_json
,table(flatten(raw_nested_book:authors));


-- ============================================================
-- 2. 型キャストを追加して文字列として取得
-- ============================================================
-- 【目的】VARIANT型の value から文字列として値を取り出す
-- 【注意】キャストなしだと "Fiona" のようにクォートが付く
-- 　　　  ::varchar でキャストすると Fiona になる

-- add a CAST command to the fields returned
SELECT value:first_name::varchar, value:last_name::varchar
from nested_ingest_json
,lateral flatten(input => raw_nested_book:authors);


-- ============================================================
-- 3. AS でカラム名を付ける
-- ============================================================
-- 【目的】結果セットに分かりやすいカラム名を付ける
-- 【動作】... AS エイリアス名 で列の表示名を変更できる

-- assign new column names to the columns using "AS"
select value:first_name::varchar as first_nm    -- first_nm: first name の略
     , value:last_name::varchar  as last_nm     -- last_nm: last name の略
from nested_ingest_json
,lateral flatten(input => raw_nested_book:authors);


-- ============================================================
-- 4. ネストJSONから特定の値を取り出す（パス記法）
-- ============================================================
-- 【目的】raw_nested_book の直下のフィールドにアクセスする
-- 【構文】カラム名:フィールド名 でアクセス（ネストは : を連続で使う）

-- 書籍の出版年を取得
select raw_nested_book:year_published
from nested_ingest_json;

-- 著者の配列全体を確認
select raw_nested_book:authors
from nested_ingest_json;

-- 著者の配列内の特定インデックスにアクセス
-- （0始まりのインデックス。[0] = 1番目の著者）
-- ※ ネストJSONではインデックスアクセスも可能
select raw_nested_book:authors[0]:first_name::varchar as first_author_first_name
from nested_ingest_json;
