-- ============================================================
-- 05_information_schema.sql
-- 対応まとめ: 04_アカウント_セキュリティ.md § 8. INFORMATION_SCHEMA
-- 目的: INFORMATION_SCHEMA の各ビューでリアルタイムメタデータを確認する
-- ============================================================

-- ============================================================
-- STEP 1: INFORMATION_SCHEMA のビュー一覧を確認
-- ============================================================
USE DATABASE SNOWFLAKE_SAMPLE_DATA;
SHOW VIEWS IN SCHEMA INFORMATION_SCHEMA;

-- ============================================================
-- STEP 2: テーブル一覧（TABLES）
-- ============================================================
SELECT
  table_schema,
  table_name,
  table_type,
  row_count,
  bytes / 1024 / 1024 AS size_mb,
  created,
  last_altered
FROM INFORMATION_SCHEMA.TABLES
WHERE table_schema NOT IN ('INFORMATION_SCHEMA')
ORDER BY bytes DESC NULLS LAST
LIMIT 20;

-- ============================================================
-- STEP 3: カラム情報（COLUMNS）
-- ============================================================
SELECT
  table_name,
  ordinal_position  AS col_no,
  column_name,
  data_type,
  character_maximum_length,
  is_nullable
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_schema = 'TPCH_SF1'
  AND table_name   = 'ORDERS'
ORDER BY ordinal_position;

-- ============================================================
-- STEP 4: スキーマ一覧（SCHEMATA）
-- ============================================================
SELECT
  schema_name,
  schema_owner,
  default_character_set_name,
  created,
  last_altered
FROM INFORMATION_SCHEMA.SCHEMATA
ORDER BY schema_name;

-- ============================================================
-- STEP 5: COPY INTO 履歴（COPY_HISTORY）
-- ACCOUNT_USAGE より遅延が少ない（リアルタイム寄り）
-- ============================================================
SELECT *
FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
  TABLE_NAME  => 'ORDERS',
  START_TIME  => DATEADD(DAY, -7, CURRENT_TIMESTAMP())
))
LIMIT 10;

-- ============================================================
-- STEP 6: タスク実行履歴（TASK_HISTORY）
-- ============================================================
SELECT
  name,
  database_name,
  schema_name,
  state,
  scheduled_time,
  completed_time,
  error_message
FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY(
  RESULT_LIMIT => 10
))
ORDER BY scheduled_time DESC;

-- ============================================================
-- STEP 7: ACCOUNT_USAGE vs INFORMATION_SCHEMA の違いを確認
-- INFORMATION_SCHEMA はリアルタイム、ACCOUNT_USAGE は遅延あり
-- ============================================================
-- INFORMATION_SCHEMA（現在の状態）
SELECT COUNT(*) AS table_count
FROM SNOWFLAKE_SAMPLE_DATA.INFORMATION_SCHEMA.TABLES
WHERE table_schema = 'TPCH_SF1';

-- ACCOUNT_USAGE（遅延あり・アカウント全体）
SELECT COUNT(*) AS table_count
FROM SNOWFLAKE.ACCOUNT_USAGE.TABLES
WHERE table_catalog = 'SNOWFLAKE_SAMPLE_DATA'
  AND table_schema  = 'TPCH_SF1'
  AND deleted IS NULL;
