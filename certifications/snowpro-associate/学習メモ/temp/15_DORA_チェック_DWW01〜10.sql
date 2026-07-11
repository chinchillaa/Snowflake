-- ============================================================
-- 15_DORA_チェック_DWW01〜10.sql
-- Snowflake DWW Badge 1 - DORA 採点チェック（DWW01〜DWW10）
-- ============================================================
-- 【重要】DORA コードは一字一句変更禁止！
--          コードを編集して合格しようとすると INVALID 扱いになる。
--          合格したい場合はラボ作業（DB・テーブル・データ）を修正すること。
--
-- 【実行前に必ず行うこと】
--   1. use database UTIL_DB;
--   2. use schema PUBLIC;
--   3. use role ACCOUNTADMIN;
--   ← この3行を実行してからDORAコードを実行する
--
-- 【採点のしくみ】
--   grader(step, (actual = expected), actual, expected, description)
--     step        : チェック名（文字列）
--     actual      : 実際の状態（サブクエリで取得）
--     expected    : 期待値（ハードコード）
--     (actual=expected): actual と expected が一致すると true（合格）
-- ============================================================


-- ============================================================
-- 事前コンテキスト設定（全DWWチェック共通）
-- ============================================================
-- 【注意】毎回 DORA チェックを実行する前にこの3行を実行すること

--You can run this code, or you can use the drop lists in your worksheet to get the context settings right.
use database UTIL_DB;
use schema PUBLIC;
use role ACCOUNTADMIN;


-- ============================================================
-- DWW01: GARDEN_PLANTS に3つのスキーマが存在するか
-- ============================================================
-- 【チェック内容】FLOWERS・VEGGIES・FRUITS の3スキーマが作成されているか
-- 【期待値】3
-- 【対応作業】GARDEN_PLANTS DB に3スキーマを作成し、PUBLIC は削除すること

--Do NOT EDIT ANYTHING BELOW THIS LINE
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT
 'DWW01' as step
 ,( select count(*)
   from GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA
   where schema_name in ('FLOWERS','VEGGIES','FRUITS')) as actual
  ,3 as expected
  ,'Created 3 Garden Plant schemas' as description
);


-- ============================================================
-- DWW02: GARDEN_PLANTS の PUBLIC スキーマが削除されているか
-- ============================================================
-- 【チェック内容】PUBLIC スキーマが0件（存在しない）か確認
-- 【期待値】0
-- 【対応作業】DROP SCHEMA GARDEN_PLANTS.PUBLIC; を実行すること

--Remember that every time you run a DORA check, the context needs to be set to the below settings.
use database UTIL_DB;
use schema PUBLIC;
use role ACCOUNTADMIN;

--Do NOT EDIT ANYTHING BELOW THIS LINE
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW02' as step
 ,( select count(*)
   from GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA
   where schema_name = 'PUBLIC') as actual
 , 0 as expected
 ,'Deleted PUBLIC schema.' as description
);


-- ============================================================
-- DWW03: ROOT_DEPTH テーブルが存在するか
-- ============================================================
-- 【チェック内容】GARDEN_PLANTS DB に ROOT_DEPTH テーブルがあるか
-- 【期待値】1
-- 【対応作業】GARDEN_PLANTS.VEGGIES.ROOT_DEPTH テーブルを作成すること

-- Do NOT EDIT ANYTHING BELOW THIS LINE
-- Remember to set your WORKSHEET context (do not add context to the grader call)
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW03' as step
 ,( select count(*)
   from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
   where table_name = 'ROOT_DEPTH') as actual
 , 1 as expected
 ,'ROOT_DEPTH Table Exists' as description
);


-- ============================================================
-- DWW04: UTIL_DB のスキーマ数が正しいか
-- ============================================================
-- 【チェック内容】UTIL_DB に INFORMATION_SCHEMA + PUBLIC の2スキーマがあるか
-- 【期待値】2
-- 【対応作業】UTIL_DB を SYSADMIN ロールで作成すること（自動で2スキーマ生成）

--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW04' as step
 ,( select count(*) as SCHEMAS_FOUND
   from UTIL_DB.INFORMATION_SCHEMA.SCHEMATA) as actual
 , 2 as expected
 , 'UTIL_DB Schemas' as description
);


-- ============================================================
-- DWW05: ROOT_DEPTH テーブルに3行あるか
-- ============================================================
-- 【チェック内容】ROOT_DEPTH の行数が3か
-- 【期待値】3
-- 【対応作業】S, M, D の3行を INSERT すること

--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW05' as step
,( select row_count
  from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
  where table_name = 'ROOT_DEPTH') as actual
, 3 as expected
,'ROOT_DEPTH row count' as description
);


-- ============================================================
-- DWW06: VEGETABLE_DETAILS テーブルが存在するか
-- ============================================================
-- 【チェック内容】GARDEN_PLANTS DB に VEGETABLE_DETAILS テーブルがあるか
-- 【期待値】1
-- 【対応作業】GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS を作成すること

--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW06' as step
 ,( select count(*)
   from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
   where table_name = 'VEGETABLE_DETAILS') as actual
 , 1 as expected
 ,'VEGETABLE_DETAILS Table' as description
);


-- ============================================================
-- DWW07: VEGETABLE_DETAILS に41行あるか
-- ============================================================
-- 【チェック内容】VEGETABLE_DETAILS の行数が41か
-- 【期待値】41（42行 - Spinach の重複1行 = 41行）
-- 【対応作業】2つのCSVをロードし、Spinach の重複行（D）を削除すること

--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW07' as step
 ,( select row_count
   from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
   where table_name = 'VEGETABLE_DETAILS') as actual
 , 41 as expected
 , 'VEG_DETAILS row count' as description
);


-- ============================================================
-- DWW08: Notebook が実行されたか
-- ============================================================
-- 【チェック内容】"Uncle Yer" という名前の Notebook が実行された記録があるか
-- 【期待値】1（実行記録が1件以上ある場合）
-- 【対応作業】"Uncle Yers Root Depth Notebook" という名前で Notebook を作成・実行すること
-- 【iff の意味】iff(条件, 真の値, 偽の値) = IF関数の Snowflake 版

--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
   SELECT 'DWW08' as step
   ,( select iff(count(*)=0, 0, count(*)/count(*))
      from table(information_schema.query_history())
      where query_text like 'execute NOTEBOOK%Uncle Yer%') as actual
   , 1 as expected
   , 'Notebook success!' as description
);


-- ============================================================
-- DWW09: Streamlit-in-Snowflake アプリが実行されたか
-- ============================================================
-- 【チェック内容】GARDEN_PLANTS.FRUITS スキーマの SiS アプリが実行された記録があるか
-- 【期待値】1
-- 【対応作業】Streamlit アプリを GARDEN_PLANTS.FRUITS に作成・実行すること
-- 【注意】ACCOUNT_USAGE.query_history は最大45分の遅延がある

--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW09' as step
 ,( select iff(count(*)=0, 0, count(*)/count(*))
    from snowflake.account_usage.query_history
    where query_text like 'execute streamlit "GARDEN_PLANTS"."FRUITS".%'
   ) as actual
 , 1 as expected
 ,'SiS App Works' as description
);


-- ============================================================
-- DWW10: MY_INTERNAL_STAGE が作成されているか
-- ============================================================
-- 【チェック内容】UTIL_DB.PUBLIC に MY_INTERNAL_STAGE（内部ステージ）があるか
-- 【期待値】1
-- 【対応作業】UTIL_DB.PUBLIC に MY_INTERNAL_STAGE を UI から作成すること
-- 【stage_type IS NULL の意味】内部ステージは stage_type に値がない（NULL）

--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DWW10' as step
  ,(
    select count(*)
    from UTIL_DB.INFORMATION_SCHEMA.stages
    where stage_name='MY_INTERNAL_STAGE'
    AND stage_type IS NULL
    ) as actual
  , 1 as expected
  , 'Internal stage created' as description
 );
