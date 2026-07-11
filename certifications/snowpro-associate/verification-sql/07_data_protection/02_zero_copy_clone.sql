-- ============================================================
-- 02_zero_copy_clone.sql
-- 対応まとめ: 07_データ保護_共有.md § 3. クローン（Zero-Copy Clone）
-- 目的: テーブル・スキーマのクローンと独立性を確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS protection_verify_db;
USE DATABASE protection_verify_db;
CREATE SCHEMA IF NOT EXISTS clone_src;
USE SCHEMA clone_src;

CREATE OR REPLACE TABLE customers (
  customer_id NUMBER,
  customer_name STRING,
  region STRING
);

INSERT INTO customers VALUES
  (1, 'Alice', 'JAPAN'),
  (2, 'Bob', 'APAC');

-- STEP 1: テーブルクローン
CREATE OR REPLACE TABLE customers_clone CLONE customers;

SELECT 'source' AS table_type, * FROM customers
UNION ALL
SELECT 'clone'  AS table_type, * FROM customers_clone;

-- STEP 2: クローン側だけ変更
UPDATE customers_clone SET region = 'EMEA' WHERE customer_id = 2;

SELECT 'source' AS table_type, * FROM customers WHERE customer_id = 2
UNION ALL
SELECT 'clone'  AS table_type, * FROM customers_clone WHERE customer_id = 2;

-- STEP 3: スキーマクローン
CREATE OR REPLACE SCHEMA clone_dst CLONE clone_src;
SHOW TABLES IN SCHEMA clone_dst;

DROP DATABASE IF EXISTS protection_verify_db;
