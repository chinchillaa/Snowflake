-- ============================================================
-- 02_datetime_boolean.sql
-- 対応まとめ: 08_データ型_SQL基礎.md § 1.3 / § 1.4
-- 目的: 日付時刻型と BOOLEAN の扱いを確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS sql_basics_verify_db;
USE DATABASE sql_basics_verify_db;
CREATE SCHEMA IF NOT EXISTS type_lab;
USE SCHEMA type_lab;

CREATE OR REPLACE TABLE sessions (
  session_id    NUMBER,
  event_date    DATE,
  event_time    TIME,
  created_ntz   TIMESTAMP_NTZ,
  created_ltz   TIMESTAMP_LTZ,
  is_active     BOOLEAN
);

INSERT INTO sessions VALUES
  (1, '2026-04-01', '09:30:00', '2026-04-01 09:30:00', CURRENT_TIMESTAMP(), TRUE),
  (2, '2026-04-02', '10:45:00', '2026-04-02 10:45:00', CURRENT_TIMESTAMP(), FALSE);

SELECT
  session_id,
  event_date,
  event_time,
  created_ntz,
  created_ltz,
  is_active
FROM sessions;

SELECT CURRENT_DATE(), CURRENT_TIME(), CURRENT_TIMESTAMP(), SYSDATE();

DROP DATABASE IF EXISTS sql_basics_verify_db;
