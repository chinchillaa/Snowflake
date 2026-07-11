-- ============================================================
-- 01_numeric_string_types.sql
-- 対応まとめ: 08_データ型_SQL基礎.md § 1.1 / § 1.2
-- 目的: 数値型・文字列型と DDL 上の型補完を確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS sql_basics_verify_db;
USE DATABASE sql_basics_verify_db;
CREATE SCHEMA IF NOT EXISTS type_lab;
USE SCHEMA type_lab;

CREATE OR REPLACE TABLE product_prices (
  product_id   INT,
  price        NUMBER(10,2),
  quantity     NUMBER(5),
  rate         FLOAT,
  product_name TEXT(20),
  country_code CHAR(2)
);

INSERT INTO product_prices VALUES
  (1, 1200.50, 3, 0.08, 'Keyboard', 'JP'),
  (2,  899.99, 5, 0.10, 'Mouse',    'US');

SELECT * FROM product_prices;

-- Snowflake が TEXT / NUMBER(p) をどう保持したか確認
SHOW CREATE TABLE product_prices;

DROP DATABASE IF EXISTS sql_basics_verify_db;
