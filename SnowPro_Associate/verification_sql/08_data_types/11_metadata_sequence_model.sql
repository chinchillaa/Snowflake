-- ============================================================
-- 11_metadata_sequence_model.sql
-- 対応まとめ: 08_データ型_SQL基礎.md § 9. INFORMATION_SCHEMA / § 12. シーケンス
-- 目的: メタデータ参照、シーケンス、基本的なリレーショナル設計を確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS sql_basics_verify_db;
USE DATABASE sql_basics_verify_db;
CREATE SCHEMA IF NOT EXISTS metadata_lab;
USE SCHEMA metadata_lab;

CREATE OR REPLACE SEQUENCE order_seq START = 1 INCREMENT = 1;

CREATE OR REPLACE TABLE customers (
  customer_id NUMBER,
  customer_name STRING
);

CREATE OR REPLACE TABLE orders (
  order_id NUMBER DEFAULT order_seq.NEXTVAL,
  customer_id NUMBER,
  amount NUMBER(10,2)
);

INSERT INTO customers VALUES (1, 'Alice'), (2, 'Bob');
INSERT INTO orders (customer_id, amount) VALUES (1, 100), (1, 200), (2, 150);

SELECT o.order_id, c.customer_name, o.amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_id;

SELECT table_name, row_count
FROM sql_basics_verify_db.information_schema.tables
WHERE table_schema = 'METADATA_LAB';

SHOW SEQUENCES IN SCHEMA metadata_lab;

DROP DATABASE IF EXISTS sql_basics_verify_db;
