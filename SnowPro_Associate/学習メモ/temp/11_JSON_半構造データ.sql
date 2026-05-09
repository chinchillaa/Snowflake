-- ============================================================
-- 11_JSON_半構造データ.sql
-- Snowflake DWW Badge 1 - JSON データの格納とクエリ
-- ============================================================
-- 【概要】
-- 半構造化データ（Semi-Structured Data）とは、
-- 列名が固定されていないデータ形式（JSON / XML / Avro など）。
-- Snowflake では VARIANT 型で格納し、コロン（:）記法でパスを指定する。
--
-- ポイント：
--   - 格納: VARIANT 型のカラムにそのまま JSON を入れる
--   - 参照: カラム名:キー名 でアクセス
--   - 型変換: ::型名 でキャストする（例: ::STRING, ::VARCHAR, ::DATE）
-- ============================================================


-- ============================================================
-- 1. JSON データの格納テーブル作成（著者データ）
-- ============================================================
-- 【目的】著者情報の JSON ファイルをそのまま格納するテーブルを作成する
-- 【VARIANT 型】どんな JSON / 半構造化データでも格納できる柔軟な型
-- 　　　　　　  1列に JSON オブジェクト1つ（または配列1要素）を格納する

// JSON DDL Scripts
use database library_card_catalog;
use role sysadmin;

// Create an Ingestion Table for JSON Data
create table library_card_catalog.public.author_ingest_json
(
  raw_author variant  -- variant: バリアント型（JSON/XML/AVRO などを格納できる）
);

-- ロード後の確認（期待行数: 6行）
select * from author_ingest_json;


-- ============================================================
-- 2. JSON ファイルフォーマット（author_with_header.json 用）
-- ============================================================
-- 【重要設定】strip_outer_array = TRUE
--   JSON ファイルの先頭に [ ] 配列があると全体が1行になってしまう。
--   strip_outer_array = TRUE で配列を展開し、要素ごとに1行として読み込む。

create file format library_card_catalog.public.json_file_format
    type = 'JSON'
    compression = 'AUTO'
    enable_octal = FALSE
    allow_duplicate = FALSE
    strip_outer_array = TRUE   -- ← 外側の [] を取り除き、各オブジェクトを1行に
    strip_null_values = FALSE
    ignore_utf8_errors = FALSE
    ;


-- ============================================================
-- 3. JSON データのクエリ（コロン記法でパスを指定）
-- ============================================================
-- 【構文】カラム名:キー名 でJSON のフィールドにアクセスする
-- 【注意】返り値はデフォルトで VARIANT 型（文字列に見えても "" が付く）
-- 　　　  ::STRING や ::VARCHAR でキャストすると通常の文字列になる

-- AUTHOR_UID の値を取得（VARIANT型として返る）
select raw_author:AUTHOR_UID
from author_ingest_json;

-- すべてのフィールドを取得し、VARIANT→STRING にキャストして正規化テーブル風に表示
SELECT
   raw_author:AUTHOR_UID                    -- VARIANT型のまま
  ,raw_author:FIRST_NAME::STRING  AS FIRST_NAME    -- ::STRING = VARCHAR へキャスト
  ,raw_author:MIDDLE_NAME::STRING AS MIDDLE_NAME
  ,raw_author:LAST_NAME::STRING   AS LAST_NAME
FROM AUTHOR_INGEST_JSON;

-- 【::STRING と ::VARCHAR の違い】
-- どちらも同じ。STRING は VARCHAR の別名。Snowflakeでは混在可。


-- ============================================================
-- 4. ネストしたJSONテーブルの作成（書籍+著者のネスト構造）
-- ============================================================
-- 【目的】書籍の中に著者情報がネストされた JSON を格納する
-- 　　　  例: {"title": "Food", "authors": [{"first_name": "Fiona"}, ...]}

-- create an Ingestion Table for the NESTED JSON Data
create or replace table library_card_catalog.public.nested_ingest_json
(
  raw_nested_book VARIANT  -- ネストしたJSONをそのまま格納
);


-- ============================================================
-- 5. ネストJSONのクエリ（パス記法でネストを辿る）
-- ============================================================
-- 【目的】ネストした書籍・著者データをフラットに展開して参照する
-- 【構文】コロンを連続して使うことでネストを辿れる
-- 　　　  例: raw_nested_book:authors でネストした配列にアクセス

-- a few simple queries
select raw_nested_book
from nested_ingest_json;

select raw_nested_book:year_published
from nested_ingest_json;

select raw_nested_book:authors
from nested_ingest_json;
