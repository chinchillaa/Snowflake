-- ============================================================
-- 04_managed_access_schema.sql
-- 対応まとめ: 05_アクセス制御_ロール.md § 6. Managed Access Schema
-- 目的: WITH MANAGED ACCESS スキーマの作成・権限集中管理を体験する
-- ============================================================

-- ============================================================
-- STEP 1: 通常スキーマと Managed Access スキーマを比較作成
-- ============================================================
CREATE DATABASE IF NOT EXISTS mas_verify_db;
USE DATABASE mas_verify_db;

-- 通常スキーマ（オブジェクトオーナーが権限付与できる）
CREATE SCHEMA IF NOT EXISTS normal_schema;

-- Managed Access スキーマ（スキーマオーナーのみが権限付与できる）
CREATE SCHEMA IF NOT EXISTS managed_schema WITH MANAGED ACCESS;

-- ============================================================
-- STEP 2: スキーマ情報の確認
-- MANAGED_ACCESS 列が YES/NO で表示される
-- ============================================================
SHOW SCHEMAS IN DATABASE mas_verify_db;

-- ============================================================
-- STEP 3: INFORMATION_SCHEMA で確認
-- ============================================================
SELECT
  schema_name,
  schema_owner,
  created,
  last_altered
FROM mas_verify_db.INFORMATION_SCHEMA.SCHEMATA
ORDER BY schema_name;

-- ============================================================
-- STEP 4: Managed Access スキーマにテーブルを作成
-- ============================================================
USE SCHEMA managed_schema;

CREATE TABLE IF NOT EXISTS sensitive_data (
  user_id    NUMBER,
  email      VARCHAR(200),
  salary     NUMBER(10,2)
);

-- ============================================================
-- STEP 5: Managed Access スキーマでの権限付与
-- スキーマオーナー（または SECURITYADMIN）のみが GRANT 可能
-- テーブルオーナーは GRANT できない（これが通常スキーマとの違い）
-- ============================================================
CREATE ROLE IF NOT EXISTS mas_reader COMMENT = 'Managed Access スキーマ読み取りロール（検証用）';

GRANT USAGE ON DATABASE mas_verify_db TO ROLE mas_reader;
GRANT USAGE ON SCHEMA managed_schema TO ROLE mas_reader;
GRANT SELECT ON TABLE sensitive_data TO ROLE mas_reader;

SHOW GRANTS TO ROLE mas_reader;

-- ============================================================
-- STEP 6: 後片付け
-- ============================================================
DROP ROLE IF EXISTS mas_reader;
DROP DATABASE IF EXISTS mas_verify_db;
