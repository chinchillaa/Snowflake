-- ============================================================
-- 05_string_functions.sql
-- 対応まとめ: 08_データ型_SQL基礎.md § 3. 文字列関数
-- 目的: 代表的な文字列関数とパターンマッチングを確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS sql_basics_verify_db;
USE DATABASE sql_basics_verify_db;
CREATE SCHEMA IF NOT EXISTS func_lab;
USE SCHEMA func_lab;

CREATE OR REPLACE TABLE customers (
  customer_id NUMBER,
  full_name   STRING,
  email       STRING
);

INSERT INTO customers VALUES
  (1, 'Alice Johnson', 'alice@example.com'),
  (2, 'Bob Smith',     'bob@test.org'),
  (3, 'Carol Tanaka',  'carol@example.com');

SELECT
  full_name,
  UPPER(full_name) AS upper_name,
  LOWER(full_name) AS lower_name,
  SUBSTR(full_name, 1, 5) AS first_five,
  REPLACE(email, '@', ' at ') AS replaced_email,
  SPLIT_PART(email, '@', 2) AS domain
FROM customers;

SELECT * FROM customers WHERE email LIKE '%@example.com';
SELECT * FROM customers WHERE REGEXP_LIKE(full_name, '^[A-Z][a-z]+');

DROP DATABASE IF EXISTS sql_basics_verify_db;
