-- ============================================================
-- 02_privileges.sql
-- 対応まとめ: 05_アクセス制御_ロール.md § 4. 権限管理 & § 10. 権限まとめ
-- 目的: GRANT/REVOKE によるオブジェクト権限の付与・確認を体験する
-- ============================================================

-- ============================================================
-- STEP 1: 検証用オブジェクトの準備
-- ============================================================
CREATE DATABASE IF NOT EXISTS priv_verify_db;
USE DATABASE priv_verify_db;
CREATE SCHEMA IF NOT EXISTS priv_verify_schema;
USE SCHEMA priv_verify_schema;

CREATE TABLE IF NOT EXISTS sales_data (
  id     NUMBER,
  amount NUMBER(10,2),
  region VARCHAR(50)
);

CREATE ROLE IF NOT EXISTS readonly_role COMMENT = '読み取り専用ロール（検証用）';
CREATE ROLE IF NOT EXISTS readwrite_role COMMENT = '読み書きロール（検証用）';

-- ============================================================
-- STEP 2: データベース・スキーマへの USAGE 権限付与
-- USAGE なしではオブジェクトにアクセスできない
-- ============================================================
GRANT USAGE ON DATABASE priv_verify_db TO ROLE readonly_role;
GRANT USAGE ON SCHEMA priv_verify_schema TO ROLE readonly_role;

GRANT USAGE ON DATABASE priv_verify_db TO ROLE readwrite_role;
GRANT USAGE ON SCHEMA priv_verify_schema TO ROLE readwrite_role;

-- ============================================================
-- STEP 3: テーブルへの権限付与
-- ============================================================
-- 読み取り専用
GRANT SELECT ON TABLE sales_data TO ROLE readonly_role;

-- 読み書き
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE sales_data TO ROLE readwrite_role;

-- ============================================================
-- STEP 4: 権限の確認
-- ============================================================
SHOW GRANTS TO ROLE readonly_role;
SHOW GRANTS TO ROLE readwrite_role;
SHOW GRANTS ON TABLE sales_data;

-- ============================================================
-- STEP 5: スキーマ内全テーブルへの一括権限付与（FUTURE GRANTS）
-- ============================================================
GRANT SELECT ON FUTURE TABLES IN SCHEMA priv_verify_schema TO ROLE readonly_role;
SHOW FUTURE GRANTS IN SCHEMA priv_verify_schema;

-- ============================================================
-- STEP 6: ウェアハウス使用権限
-- ============================================================
-- GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE readonly_role;

-- ============================================================
-- STEP 7: 権限の取り消し（REVOKE）
-- ============================================================
REVOKE INSERT, UPDATE, DELETE ON TABLE sales_data FROM ROLE readwrite_role;
SHOW GRANTS TO ROLE readwrite_role;

-- ============================================================
-- STEP 8: 後片付け
-- ============================================================
DROP ROLE IF EXISTS readonly_role;
DROP ROLE IF EXISTS readwrite_role;
DROP DATABASE IF EXISTS priv_verify_db;
