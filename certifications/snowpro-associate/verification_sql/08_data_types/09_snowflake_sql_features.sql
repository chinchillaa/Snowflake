-- ============================================================
-- 09_snowflake_sql_features.sql
-- 対応まとめ: 08_データ型_SQL基礎.md § 7. Snowflake 固有の SQL 機能
-- 目的: QUALIFY、SAMPLE、LIMIT / TOP を確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS sql_basics_verify_db;
USE DATABASE sql_basics_verify_db;
CREATE SCHEMA IF NOT EXISTS feature_lab;
USE SCHEMA feature_lab;

CREATE OR REPLACE TABLE product_sales (
  product_id NUMBER,
  category   STRING,
  amount     NUMBER(10,2)
);

INSERT INTO product_sales VALUES
  (1, 'A', 100),
  (2, 'A', 120),
  (3, 'B', 200),
  (4, 'B', 150),
  (5, 'C', 180);

-- STEP 1: QUALIFY
SELECT
  product_id,
  category,
  amount,
  ROW_NUMBER() OVER (PARTITION BY category ORDER BY amount DESC) AS rn
FROM product_sales
QUALIFY rn = 1;

-- STEP 2: SAMPLE
SELECT * FROM product_sales SAMPLE (50);

-- STEP 3: LIMIT / TOP
SELECT * FROM product_sales ORDER BY amount DESC LIMIT 2;
SELECT TOP 2 * FROM product_sales ORDER BY amount DESC;

DROP DATABASE IF EXISTS sql_basics_verify_db;
