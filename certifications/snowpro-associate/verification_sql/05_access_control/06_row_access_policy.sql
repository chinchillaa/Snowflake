-- ============================================================
-- 06_row_access_policy.sql
-- 対応まとめ: 05_アクセス制御_ロール.md § 8. 行アクセスポリシー
-- 目的: Row Access Policy の作成・適用・動作確認を体験する
-- ============================================================

-- ============================================================
-- STEP 1: 検証用データベースとテーブルの準備
-- ============================================================
CREATE DATABASE IF NOT EXISTS rap_verify_db;
USE DATABASE rap_verify_db;
CREATE SCHEMA IF NOT EXISTS rap_schema;
USE SCHEMA rap_schema;

-- 地域別の売上データ
CREATE TABLE IF NOT EXISTS regional_sales (
  sales_id  NUMBER,
  region    VARCHAR(20),
  amount    NUMBER(10,2),
  rep_name  VARCHAR(50)
);

INSERT INTO regional_sales VALUES
  (1, 'JAPAN',  50000, 'Alice'),
  (2, 'JAPAN',  32000, 'Bob'),
  (3, 'APAC',   88000, 'Charlie'),
  (4, 'APAC',   45000, 'Diana'),
  (5, 'EMEA',   72000, 'Eve'),
  (6, 'EMEA',   61000, 'Frank');

-- ============================================================
-- STEP 2: 行アクセスポリシーの作成
-- ロールに応じて参照できる地域を制限する
-- ACCOUNTADMIN は全件参照可能
-- ============================================================
CREATE ROW ACCESS POLICY IF NOT EXISTS region_access_policy
  AS (row_region VARCHAR) RETURNS BOOLEAN ->
    CASE
      WHEN CURRENT_ROLE() = 'ACCOUNTADMIN' THEN TRUE
      WHEN CURRENT_ROLE() = 'JAPAN_ROLE'   THEN row_region = 'JAPAN'
      WHEN CURRENT_ROLE() = 'APAC_ROLE'    THEN row_region IN ('JAPAN', 'APAC')
      ELSE FALSE
    END;

-- ============================================================
-- STEP 3: テーブルにポリシーを適用
-- ============================================================
ALTER TABLE regional_sales
  ADD ROW ACCESS POLICY region_access_policy ON (region);

-- ============================================================
-- STEP 4: ポリシー適用の確認
-- ============================================================
SHOW ROW ACCESS POLICIES;
DESC ROW ACCESS POLICY region_access_policy;

-- テーブルへの適用状況
SELECT
  policy_name,
  ref_entity_name,
  ref_column_names
FROM SNOWFLAKE.ACCOUNT_USAGE.POLICY_REFERENCES
WHERE policy_kind = 'ROW_ACCESS_POLICY'
  AND ref_database_name = 'RAP_VERIFY_DB';

-- ============================================================
-- STEP 5: データ確認（ACCOUNTADMIN では全件見える）
-- ============================================================
SELECT * FROM regional_sales;

-- CURRENT_ROLE で確認
SELECT CURRENT_ROLE();

-- ============================================================
-- STEP 6: ポリシー参照の確認（INFORMATION_SCHEMA）
-- ============================================================
SELECT *
FROM TABLE(rap_verify_db.INFORMATION_SCHEMA.POLICY_REFERENCES(
  POLICY_NAME => 'rap_schema.region_access_policy'
));

-- ============================================================
-- STEP 7: 後片付け
-- テーブルからポリシーを解除してからポリシーを削除
-- ============================================================
ALTER TABLE regional_sales
  DROP ROW ACCESS POLICY region_access_policy;

DROP ROW ACCESS POLICY IF EXISTS region_access_policy;
DROP DATABASE IF EXISTS rap_verify_db;
