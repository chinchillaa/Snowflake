-- ============================================================
-- 04_cast_conversion.sql
-- 対応まとめ: 08_データ型_SQL基礎.md § 2. 型変換（キャスト）
-- 目的: CAST / :: 記法 / TO_DATE などの変換を確認する
-- ============================================================

SELECT
  CAST('123' AS INT) AS cast_int,
  '456'::INT AS shorthand_int,
  CAST(42 AS VARCHAR) AS cast_str,
  TO_DATE('2026/04/03', 'YYYY/MM/DD') AS converted_date,
  TO_TIMESTAMP('2026-04-03 14:30:00', 'YYYY-MM-DD HH24:MI:SS') AS converted_ts,
  TO_NUMBER('1,234.56', '9,999.99') AS converted_num;

CREATE DATABASE IF NOT EXISTS sql_basics_verify_db;
USE DATABASE sql_basics_verify_db;
CREATE SCHEMA IF NOT EXISTS type_lab;
USE SCHEMA type_lab;

CREATE OR REPLACE TABLE json_events (event_data VARIANT);
INSERT INTO json_events VALUES
  (PARSE_JSON('{"user":{"name":"田中","age":30},"purchased":true}'));

SELECT
  event_data:user:name::STRING AS user_name,
  event_data:user:age::INT AS user_age,
  event_data:purchased::BOOLEAN AS purchased
FROM json_events;

DROP DATABASE IF EXISTS sql_basics_verify_db;
