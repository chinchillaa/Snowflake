-- ============================================================
-- 07_null_conditional.sql
-- 対応まとめ: 08_データ型_SQL基礎.md § 5. 条件関数
-- 目的: NULL処理と CASE / IFF を確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS sql_basics_verify_db;
USE DATABASE sql_basics_verify_db;
CREATE SCHEMA IF NOT EXISTS func_lab;
USE SCHEMA func_lab;

CREATE OR REPLACE TABLE orders (
  order_id NUMBER,
  discount NUMBER(10,2),
  status   STRING
);

INSERT INTO orders VALUES
  (1, NULL, 'NEW'),
  (2, 10,   'PAID'),
  (3, NULL, 'CANCELLED');

SELECT
  order_id,
  discount,
  COALESCE(discount, 0) AS discount_filled,
  NVL(discount, 0) AS discount_nvl,
  CASE
    WHEN status = 'PAID' THEN 'closed'
    WHEN status = 'CANCELLED' THEN 'stopped'
    ELSE 'open'
  END AS status_group,
  IFF(discount IS NULL, 'no_discount', 'has_discount') AS discount_flag
FROM orders
ORDER BY order_id;

DROP DATABASE IF EXISTS sql_basics_verify_db;
