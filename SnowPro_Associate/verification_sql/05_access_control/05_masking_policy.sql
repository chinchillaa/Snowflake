-- ============================================================
-- 05_masking_policy.sql
-- 対応まとめ: 05_アクセス制御_ロール.md § 7. データマスキング
-- 目的: Dynamic Data Masking ポリシーの作成・適用・動作確認を体験する
-- ============================================================

-- ============================================================
-- STEP 1: 検証用データベースとテーブルの準備
-- ============================================================
CREATE DATABASE IF NOT EXISTS mask_verify_db;
USE DATABASE mask_verify_db;
CREATE SCHEMA IF NOT EXISTS mask_schema;
USE SCHEMA mask_schema;

CREATE TABLE IF NOT EXISTS customer_pii (
  customer_id  NUMBER,
  email        VARCHAR(200),
  phone        VARCHAR(20),
  credit_card  VARCHAR(20)
);

INSERT INTO customer_pii VALUES
  (1, 'alice@example.com',  '090-1234-5678', '4111-1111-1111-1111'),
  (2, 'bob@example.com',    '080-9876-5432', '5500-0000-0000-0004'),
  (3, 'charlie@example.com','070-1111-2222', '3714-496353-98431');

-- ============================================================
-- STEP 2: メールアドレスのマスキングポリシー作成
-- ANALYST ロールは実データを参照可能、それ以外はマスク表示
-- ============================================================
CREATE MASKING POLICY IF NOT EXISTS email_mask
  AS (val STRING) RETURNS STRING ->
    CASE
      WHEN CURRENT_ROLE() IN ('ACCOUNTADMIN', 'SYSADMIN') THEN val
      ELSE REGEXP_REPLACE(val, '.+@', '****@')
    END;

-- ============================================================
-- STEP 3: クレジットカード番号のマスキングポリシー
-- 最後の4桁のみ表示
-- ============================================================
CREATE MASKING POLICY IF NOT EXISTS cc_mask
  AS (val STRING) RETURNS STRING ->
    CASE
      WHEN CURRENT_ROLE() IN ('ACCOUNTADMIN', 'SYSADMIN') THEN val
      ELSE CONCAT('****-****-****-', RIGHT(REPLACE(val, '-', ''), 4))
    END;

-- ============================================================
-- STEP 4: テーブルのカラムにポリシーを適用
-- ============================================================
ALTER TABLE customer_pii
  MODIFY COLUMN email SET MASKING POLICY email_mask;

ALTER TABLE customer_pii
  MODIFY COLUMN credit_card SET MASKING POLICY cc_mask;

-- ============================================================
-- STEP 5: 適用されたポリシーを確認
-- ============================================================
DESC TABLE customer_pii;
-- → policy_name 列でポリシー名が確認できる

-- ACCOUNT_USAGE で一覧確認
SELECT
  policy_name,
  policy_kind,
  ref_database_name,
  ref_schema_name,
  ref_entity_name,
  ref_column_name
FROM SNOWFLAKE.ACCOUNT_USAGE.POLICY_REFERENCES
WHERE policy_kind = 'MASKING_POLICY'
  AND ref_database_name = 'MASK_VERIFY_DB';

-- ============================================================
-- STEP 6: データ確認（現在のロールでマスクが適用される）
-- ============================================================
SELECT * FROM customer_pii;
-- ACCOUNTADMIN/SYSADMIN ロールでは実データが表示される

-- ============================================================
-- STEP 7: マスキングポリシーの一覧確認
-- ============================================================
SHOW MASKING POLICIES;

-- ============================================================
-- STEP 8: ポリシーの変更（NULL 返却に変更）
-- ============================================================
-- ALTER MASKING POLICY email_mask SET BODY ->
--   CASE
--     WHEN CURRENT_ROLE() IN ('ACCOUNTADMIN', 'SYSADMIN') THEN val
--     ELSE NULL
--   END;

-- ============================================================
-- STEP 9: 後片付け
-- カラムからポリシーを解除してからポリシーを削除
-- ============================================================
ALTER TABLE customer_pii MODIFY COLUMN email   UNSET MASKING POLICY;
ALTER TABLE customer_pii MODIFY COLUMN credit_card UNSET MASKING POLICY;

DROP MASKING POLICY IF EXISTS email_mask;
DROP MASKING POLICY IF EXISTS cc_mask;
DROP DATABASE IF EXISTS mask_verify_db;
