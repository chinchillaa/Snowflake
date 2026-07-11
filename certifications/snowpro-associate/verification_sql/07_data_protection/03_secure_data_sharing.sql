-- ============================================================
-- 03_secure_data_sharing.sql
-- 対応まとめ: 07_データ保護_共有.md § 4. Secure Data Sharing
-- 目的: Share、Secure View、consumer側DB作成の流れを確認する
-- 注意: 実アカウント共有には相手アカウント識別子が必要
-- ============================================================

CREATE DATABASE IF NOT EXISTS sharing_verify_db;
USE DATABASE sharing_verify_db;
CREATE SCHEMA IF NOT EXISTS provider_lab;
USE SCHEMA provider_lab;

CREATE OR REPLACE TABLE sales_summary (
  sales_date DATE,
  region     STRING,
  amount     NUMBER(10,2)
);

INSERT INTO sales_summary VALUES
  ('2026-04-01', 'JAPAN', 1000),
  ('2026-04-01', 'APAC',  2000);

CREATE OR REPLACE SECURE VIEW secure_sales_v AS
SELECT sales_date, region, amount
FROM sales_summary;

-- STEP 1: Share作成
CREATE SHARE IF NOT EXISTS sales_share;

-- STEP 2: 共有対象を付与
GRANT USAGE ON DATABASE sharing_verify_db TO SHARE sales_share;
GRANT USAGE ON SCHEMA sharing_verify_db.provider_lab TO SHARE sales_share;
GRANT SELECT ON VIEW secure_sales_v TO SHARE sales_share;

-- STEP 3: 共有内容確認
SHOW SHARES;
SHOW GRANTS TO SHARE sales_share;

-- STEP 4: consumer側の例
-- CREATE DATABASE consumer_sales_db FROM SHARE provider_account.sales_share;

DROP DATABASE IF EXISTS sharing_verify_db;
DROP SHARE IF EXISTS sales_share;
