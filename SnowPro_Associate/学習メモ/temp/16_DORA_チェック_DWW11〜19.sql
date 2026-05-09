-- ============================================================
-- 16_DORA_チェック_DWW11〜19.sql
-- Snowflake DWW Badge 1 - DORA 採点チェック（DWW11〜DWW19）
-- ============================================================
-- 【重要】DORA コードは一字一句変更禁止！
-- 【実行前】必ず以下3行を先に実行すること：
--   use database UTIL_DB;
--   use schema PUBLIC;
--   use role ACCOUNTADMIN;
-- ============================================================


-- ============================================================
-- 事前コンテキスト設定（全DWWチェック共通）
-- ============================================================

-- Set your worksheet drop lists
use database UTIL_DB;
use schema PUBLIC;
use role ACCOUNTADMIN;


-- ============================================================
-- DWW11: VEGETABLE_DETAILS_SOIL_TYPE に42行あるか
-- ============================================================
-- 【チェック内容】COPY INTO で VEG_NAME_TO_SOIL_TYPE_PIPE.txt をロード後の行数
-- 【期待値】42
-- 【対応作業】VEGETABLE_DETAILS_SOIL_TYPE テーブルを作成し、パイプ区切りファイルをロードすること

--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
  SELECT 'DWW11' as step
  ,( select row_count
    from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
    where table_name = 'VEGETABLE_DETAILS_SOIL_TYPE') as actual
  , 42 as expected
  , 'Veg Det Soil Type Count' as description
 );


-- ============================================================
-- DWW12: VEGETABLE_DETAILS_PLANT_HEIGHT に41行あるか
-- ============================================================
-- 【チェック内容】veg_plant_height.csv をロード後の行数
-- 【期待値】41
-- 【対応作業】VEGETABLE_DETAILS_PLANT_HEIGHT テーブルを作成し、
-- 　　　　　　既存のファイルフォーマットを使って CSV ファイルをロードすること

--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
      SELECT 'DWW12' as step
      ,( select row_count
        from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
        where table_name = 'VEGETABLE_DETAILS_PLANT_HEIGHT') as actual
      , 41 as expected
      , 'Veg Detail Plant Height Count' as description
);


-- ============================================================
-- DWW13: LU_SOIL_TYPE に8行あるか
-- ============================================================
-- 【チェック内容】LU_SOIL_TYPE.tsv をロード後の行数
-- 【期待値】8
-- 【対応作業】L9_CHALLENGE_FF（タブ区切りフォーマット）を作成して
-- 　　　　　　LU_SOIL_TYPE テーブルにロードすること

--Set your worksheet drop list role to ACCOUNTADMIN
--Set your worksheet drop list database and schema to the location of your GRADER function

-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
     SELECT 'DWW13' as step
     ,( select row_count
       from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES
       where table_name = 'LU_SOIL_TYPE') as actual
     , 8 as expected
     ,'Soil Type Look Up Table' as description
);


-- ============================================================
-- DWW14: L9_CHALLENGE_FF ファイルフォーマットが正しいか
-- ============================================================
-- 【チェック内容】FIELD_DELIMITER = '\t'（タブ）の L9_CHALLENGE_FF があるか
-- 【期待値】1
-- 【対応作業】TYPE='CSV', FIELD_DELIMITER='\t' で L9_CHALLENGE_FF を作成すること

-- Set your worksheet drop lists
-- DO NOT EDIT THE CODE
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
     SELECT 'DWW14' as step
     ,( select count(*)
       from GARDEN_PLANTS.INFORMATION_SCHEMA.FILE_FORMATS
       where FILE_FORMAT_NAME='L9_CHALLENGE_FF'
       and FIELD_DELIMITER = '\t') as actual
     , 1 as expected
     ,'Challenge File Format Created' as description
);


-- ============================================================
-- DWW15: LIBRARY_CARD_CATALOG の3テーブルJOINで6行取得できるか
-- ============================================================
-- 【チェック内容】BOOK・AUTHOR・BOOK_TO_AUTHOR の3テーブルをJOINして6行あるか
-- 【期待値】6（著者6人分）
-- 【対応作業】3テーブルを作成し、データを挿入してリレーションを正しく設定すること

-- Set your worksheet drop lists
-- DO NOT EDIT THE CODE
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
     SELECT 'DWW15' as step
     ,( select count(*)
      from LIBRARY_CARD_CATALOG.PUBLIC.Book_to_Author ba
      join LIBRARY_CARD_CATALOG.PUBLIC.author a
      on ba.author_uid = a.author_uid
      join LIBRARY_CARD_CATALOG.PUBLIC.book b
      on b.book_uid=ba.book_uid) as actual
     , 6 as expected
     , '3NF DB was Created.' as description
);


-- ============================================================
-- DWW16: AUTHOR_INGEST_JSON に6行あるか
-- ============================================================
-- 【チェック内容】author_with_header.json をロード後の行数
-- 【期待値】6
-- 【対応作業】VARIANT型テーブル・JSONファイルフォーマット（strip_outer_array=TRUE）を
-- 　　　　　　作成してロードすること

-- Set your worksheet drop lists. DO NOT EDIT THE DORA CODE.
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
  SELECT 'DWW16' as step
  ,( select row_count
    from LIBRARY_CARD_CATALOG.INFORMATION_SCHEMA.TABLES
    where table_name = 'AUTHOR_INGEST_JSON') as actual
  ,6 as expected
  ,'Check number of rows' as description
 );


-- ============================================================
-- DWW17: NESTED_INGEST_JSON に5行あるか
-- ============================================================
-- 【チェック内容】json_book_author_nested.txt をロード後の行数
-- 【期待値】5
-- 【対応作業】NESTED_INGEST_JSON テーブルを作成し、ネストJSONファイルをロードすること

-- Set your worksheet drop lists. DO NOT EDIT THE DORA CODE.
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
     SELECT 'DWW17' as step
      ,( select row_count
        from LIBRARY_CARD_CATALOG.INFORMATION_SCHEMA.TABLES
        where table_name = 'NESTED_INGEST_JSON') as actual
      , 5 as expected
      ,'Check number of rows' as description
);


-- ============================================================
-- DWW18: TWEET_INGEST に9行あるか
-- ============================================================
-- 【チェック内容】nutrition_tweets.json をロード後の行数
-- 【期待値】9（ツイート9件）
-- 【対応作業】SOCIAL_MEDIA_FLOODGATES DB に TWEET_INGEST テーブルを作成し、
-- 　　　　　　JSON ファイルをロードすること（1ツイート=1行になるよう設定）

-- Set your worksheet drop lists. DO NOT EDIT THE DORA CODE.
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
   SELECT 'DWW18' as step
  ,( select row_count
    from SOCIAL_MEDIA_FLOODGATES.INFORMATION_SCHEMA.TABLES
    where table_name = 'TWEET_INGEST') as actual
  , 9 as expected
  ,'Check number of rows' as description
 );


-- ============================================================
-- DWW19: HASHTAGS_NORMALIZED ビューが存在するか
-- ============================================================
-- 【チェック内容】SOCIAL_MEDIA_FLOODGATES.PUBLIC に HASHTAGS_NORMALIZED ビューがあるか
-- 【期待値】1
-- 【対応作業】HASHTAGS_NORMALIZED という名前のビューを
-- 　　　　　　SOCIAL_MEDIA_FLOODGATES.PUBLIC に作成すること

-- Set your worksheet drop lists. DO NOT EDIT THE DORA CODE.
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
  SELECT 'DWW19' as step
  ,( select count(*)
    from SOCIAL_MEDIA_FLOODGATES.INFORMATION_SCHEMA.VIEWS
    where table_name = 'HASHTAGS_NORMALIZED') as actual
  , 1 as expected
  ,'Check number of rows' as description
 );

-- ============================================================
-- 【全チェック完了後の確認】
-- ============================================================
-- DWW01〜DWW19 すべてが PASSING かつ VALID であれば Badge が発行される。
-- YSA App（https://ysa.snowflakeuniversity.com）でステータスを確認すること。
-- ============================================================
