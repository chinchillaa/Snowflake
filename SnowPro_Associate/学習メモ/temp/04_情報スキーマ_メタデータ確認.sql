-- ============================================================
-- 04_情報スキーマ_メタデータ確認.sql
-- Snowflake DWW Badge 1 - INFORMATION_SCHEMA を使ったメタデータ確認
-- ============================================================
-- 【概要】
-- 「メタデータ」= データについてのデータ。
-- INFORMATION_SCHEMA はすべての Snowflake データベースに自動作成される
-- 読み取り専用のスキーマで、DB 内のオブジェクト情報（スキーマ名・
-- テーブル名・行数など）を格納している。
--
-- 主なビュー：
--   SCHEMATA : スキーマの一覧情報
--   TABLES   : テーブルの一覧情報（行数・作成日時など）
--   FILE_FORMATS : ファイルフォーマット一覧
--   STAGES   : ステージ一覧
-- ============================================================


-- ============================================================
-- 1. スキーマの全件確認
-- ============================================================
-- 【目的】GARDEN_PLANTS DB に作成したスキーマを確認する
-- 【動作】SCHEMATA ビューはそのDBに存在するスキーマの一覧を返す
-- 【注意】INFORMATION_SCHEMA 自体のレコードも含まれる

select *
from garden_plants.information_schema.schemata;


-- ============================================================
-- 2. 特定のスキーマ名でフィルタ
-- ============================================================
-- 【目的】VEGGIES・FRUITS・FLOWERS の3スキーマが存在するか確認する
-- 【動作】WHERE ... IN (...) で複数の値を一度にフィルタリングする

SELECT *
FROM GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA
where schema_name in ('FLOWERS', 'FRUITS', 'VEGGIES');


-- ============================================================
-- 3. 正しい名前のスキーマ数をカウント
-- ============================================================
-- 【目的】3つのスキーマが正しく作成されているか数値で確認する
-- 【動作】count(*) は条件に一致した行数を返す
-- 　　　  '3' を期待値として並べて表示することで差異を視覚化できる

select count(*) as schemas_found, '3' as schemas_expected
from GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA
where schema_name in ('FLOWERS', 'FRUITS', 'VEGGIES');


-- ============================================================
-- 4. テーブル確認（TABLES ビュー）
-- ============================================================
-- 【目的】ROOT_DEPTH テーブルが存在するか確認する
-- 【動作】TABLES ビューには table_name, row_count, created などが含まれる

select *
from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
where table_name = 'ROOT_DEPTH';

-- 行数だけを取得する
select row_count
from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
where table_name = 'ROOT_DEPTH';


-- ============================================================
-- 5. UTIL_DB のスキーマ数確認
-- ============================================================
-- 【目的】UTIL_DB が正しくセットアップされているか確認する
-- 【期待値】2（INFORMATION_SCHEMA + PUBLIC）

select count(*) as schemas_found
from UTIL_DB.INFORMATION_SCHEMA.SCHEMATA;


-- ============================================================
-- 6. ファイルフォーマット確認（FILE_FORMATS ビュー）
-- ============================================================
-- 【目的】指定の名前・設定のファイルフォーマットが存在するか確認する
-- 【使用場面】DORA DWW14 で L9_CHALLENGE_FF の存在を確認

select *
from GARDEN_PLANTS.INFORMATION_SCHEMA.FILE_FORMATS
where FILE_FORMAT_NAME = 'L9_CHALLENGE_FF'
  and FIELD_DELIMITER = '\t';   -- \t はタブ文字を表すエスケープシーケンス


-- ============================================================
-- 7. ステージ確認（STAGES ビュー）
-- ============================================================
-- 【目的】MY_INTERNAL_STAGE が作成されているか確認する
-- 【注意】stage_type IS NULL は「内部ステージ」を意味する
-- 　　　  外部ステージ（S3/Azure/GCS）は stage_type に値が入る

select count(*)
from UTIL_DB.INFORMATION_SCHEMA.stages
where stage_name = 'MY_INTERNAL_STAGE'
  AND stage_type IS NULL;
