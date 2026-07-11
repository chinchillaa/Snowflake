-- ============================================================
-- 03_semi_structured_binary.sql
-- 対応まとめ: 08_データ型_SQL基礎.md § 1.5 / § 1.6
-- 目的: VARIANT / OBJECT / ARRAY / BINARY を確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS sql_basics_verify_db;
USE DATABASE sql_basics_verify_db;
CREATE SCHEMA IF NOT EXISTS type_lab;
USE SCHEMA type_lab;

CREATE OR REPLACE TABLE mixed_payloads (
  payload_id NUMBER,
  variant_col VARIANT,
  binary_col  BINARY
);

INSERT INTO mixed_payloads VALUES
  (
    1,
    PARSE_JSON('{"user":"alice","roles":["admin","analyst"],"score":98}'),
    TO_BINARY('DEADBEEF', 'HEX')
  );

SELECT
  payload_id,
  variant_col:user::STRING AS user_name,
  variant_col:roles[0]::STRING AS first_role,
  TO_VARCHAR(binary_col, 'HEX') AS binary_hex
FROM mixed_payloads;

SELECT
  OBJECT_CONSTRUCT('name', 'Bob', 'age', 30) AS obj_example,
  ARRAY_CONSTRUCT('red', 'blue', 'green') AS arr_example;

DROP DATABASE IF EXISTS sql_basics_verify_db;
