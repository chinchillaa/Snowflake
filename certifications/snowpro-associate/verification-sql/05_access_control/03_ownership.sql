-- ============================================================
-- 03_ownership.sql
-- 対応まとめ: 05_アクセス制御_ロール.md § 5. オーナーシップ
-- 目的: オブジェクトのオーナーシップ確認・移譲・影響を体験する
-- ============================================================

-- ============================================================
-- STEP 1: 検証用オブジェクトの準備
-- ============================================================
CREATE DATABASE IF NOT EXISTS ownership_verify_db;
USE DATABASE ownership_verify_db;
CREATE SCHEMA IF NOT EXISTS ownership_schema;

CREATE TABLE IF NOT EXISTS ownership_schema.target_table (
  id   NUMBER,
  data VARCHAR(100)
);

-- ============================================================
-- STEP 2: 現在のオーナーを確認
-- ============================================================
SHOW TABLES IN SCHEMA ownership_schema;
-- → owner 列でオーナーロールを確認

SHOW SCHEMAS IN DATABASE ownership_verify_db;
SHOW DATABASES LIKE 'OWNERSHIP_VERIFY_DB';

-- ============================================================
-- STEP 3: INFORMATION_SCHEMA でオーナー確認
-- ============================================================
SELECT
  table_name,
  table_owner,
  table_type,
  created
FROM ownership_verify_db.INFORMATION_SCHEMA.TABLES
WHERE table_schema = 'OWNERSHIP_SCHEMA';

-- ============================================================
-- STEP 4: オーナーシップの移譲（TRANSFER OF OWNERSHIP）
-- 移譲先ロールが存在する場合のみ実行可能
-- ============================================================
CREATE ROLE IF NOT EXISTS new_owner_role COMMENT = 'オーナーシップ移譲先ロール（検証用）';

-- オーナーシップ移譲
-- GRANT OWNERSHIP ON TABLE ownership_schema.target_table
--   TO ROLE new_owner_role COPY CURRENT GRANTS;
-- → COPY CURRENT GRANTS: 既存の権限付与を引き継ぐ

-- 移譲後に元のロールがアクセスするには USAGE/SELECT が必要になる

-- ============================================================
-- STEP 5: ACCOUNT_USAGE でオーナーシップ履歴を確認
-- ============================================================
SELECT
  object_name,
  object_type,
  granted_on,
  grantee_name,
  granted_by
FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
WHERE privilege = 'OWNERSHIP'
  AND object_name ILIKE '%TARGET_TABLE%'
ORDER BY granted_on DESC
LIMIT 10;

-- ============================================================
-- STEP 6: 後片付け
-- ============================================================
DROP ROLE IF EXISTS new_owner_role;
DROP DATABASE IF EXISTS ownership_verify_db;
