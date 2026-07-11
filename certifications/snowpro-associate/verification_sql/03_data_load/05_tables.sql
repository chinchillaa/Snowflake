-- ============================================================
-- 05_tables.sql
-- 対応まとめ: 03_データ管理_ロード.md § 6. テーブルの種類
-- 目的: Permanent / Transient / Temporary テーブルの違いを確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS verify_tables_db;
USE DATABASE verify_tables_db;
CREATE SCHEMA IF NOT EXISTS public;
USE SCHEMA public;
CREATE WAREHOUSE IF NOT EXISTS verify_wh WAREHOUSE_SIZE = 'X-SMALL' AUTO_SUSPEND = 60 AUTO_RESUME = TRUE;
USE WAREHOUSE verify_wh;

-- ============================================================
-- STEP 1: Permanent テーブル（デフォルト）
-- Time Travel = 最大 90日（Standardエディションは1日）
-- Fail-safe = 7日
-- ============================================================
CREATE TABLE permanent_example (
  id   INT,
  name VARCHAR(100)
);

-- テーブルのプロパティ確認（retention_time, table_type 列に注目）
SHOW TABLES LIKE 'PERMANENT_EXAMPLE';

-- ============================================================
-- STEP 2: Transient テーブル
-- Time Travel = 最大 1日
-- Fail-safe = なし → ストレージコストが安い
-- ============================================================
CREATE TRANSIENT TABLE transient_example (
  id       INT,
  raw_data VARIANT
);

SHOW TABLES LIKE 'TRANSIENT_EXAMPLE';
-- → table_type が 'TRANSIENT' になることを確認

-- ============================================================
-- STEP 3: Temporary テーブル（セッション終了で消滅）
-- ============================================================
CREATE TEMPORARY TABLE temp_example (
  calc_value NUMBER(10, 2)
);

INSERT INTO temp_example VALUES (100.0), (200.5), (300.75);
SELECT * FROM temp_example;

SHOW TABLES LIKE 'TEMP_EXAMPLE';
-- → table_type が 'TEMPORARY' になることを確認

-- ============================================================
-- STEP 4: DATA_RETENTION_TIME_IN_DAYS でTime Travelを明示設定
-- ============================================================
CREATE TABLE custom_retention (
  id INT
) DATA_RETENTION_TIME_IN_DAYS = 7;

-- 設定の変更
ALTER TABLE custom_retention SET DATA_RETENTION_TIME_IN_DAYS = 1;

-- Transient では最大1日（0または1のみ設定可能）
CREATE TRANSIENT TABLE transient_with_retention (
  id INT
) DATA_RETENTION_TIME_IN_DAYS = 1;

-- ============================================================
-- STEP 5: テーブル一覧で kind / retention_time を比較
-- ============================================================
SHOW TABLES;
-- 各テーブルの TABLE_TYPE と RETENTION_TIME を比較する

-- ============================================================
-- STEP 6: 後片付け
-- ============================================================
DROP TABLE IF EXISTS permanent_example;
DROP TABLE IF EXISTS transient_example;
DROP TABLE IF EXISTS temp_example;
DROP TABLE IF EXISTS custom_retention;
DROP TABLE IF EXISTS transient_with_retention;
DROP DATABASE IF EXISTS verify_tables_db;
DROP WAREHOUSE IF EXISTS verify_wh;
