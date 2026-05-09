-- ============================================================
-- 02_materialized_view.sql
-- 対応まとめ: 09_高度なオブジェクト_データレイク.md § 2. マテリアライズドビュー
-- 目的: MV と Secure MV の作成例を確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS advanced_obj_verify_db;
USE DATABASE advanced_obj_verify_db;
CREATE SCHEMA IF NOT EXISTS lake_lab;
USE SCHEMA lake_lab;

CREATE OR REPLACE TABLE sales (
  region STRING,
  amount NUMBER(10,2)
);

INSERT INTO sales VALUES
  ('JAPAN', 100), ('JAPAN', 150), ('APAC', 200);

CREATE OR REPLACE MATERIALIZED VIEW mv_sales_by_region AS
SELECT region, SUM(amount) AS total_amount
FROM sales
GROUP BY region;

CREATE OR REPLACE SECURE MATERIALIZED VIEW smv_large_sales AS
SELECT region, amount
FROM sales
WHERE amount >= 150;

SELECT * FROM mv_sales_by_region ORDER BY region;
SELECT * FROM smv_large_sales ORDER BY amount DESC;

SHOW MATERIALIZED VIEWS;

DROP DATABASE IF EXISTS advanced_obj_verify_db;
