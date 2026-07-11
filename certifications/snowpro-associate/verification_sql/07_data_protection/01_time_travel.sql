-- ============================================================
-- 01_time_travel.sql
-- 対応まとめ: 07_データ保護_共有.md § 1. Time Travel / § 2. Fail-safe
-- 目的: Time Travel、UNDROP、保持期間設定を確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS protection_verify_db;
USE DATABASE protection_verify_db;
CREATE SCHEMA IF NOT EXISTS tt_lab;
USE SCHEMA tt_lab;

CREATE OR REPLACE TABLE orders (
  order_id NUMBER,
  status   STRING,
  amount   NUMBER(10,2)
)
DATA_RETENTION_TIME_IN_DAYS = 1;

INSERT INTO orders VALUES
  (1, 'NEW', 100),
  (2, 'NEW', 250),
  (3, 'DONE', 300);

-- STEP 1: 保持期間確認
SHOW TABLES LIKE 'ORDERS';

-- STEP 2: データ変更
UPDATE orders SET status = 'CANCELLED' WHERE order_id = 2;
DELETE FROM orders WHERE order_id = 1;

-- STEP 3: 直前状態の参照
SELECT * FROM orders BEFORE(STATEMENT => LAST_QUERY_ID());

-- STEP 4: 1つ前の状態から別テーブルを作成
CREATE OR REPLACE TABLE orders_restore_candidate AS
SELECT * FROM orders AT(OFFSET => -60);

-- STEP 5: UNDROP確認
DROP TABLE orders_restore_candidate;
UNDROP TABLE orders_restore_candidate;

-- STEP 6: Fail-safe はユーザー自身では操作できないため概念確認のみ
-- Permanent Table は Time Travel 終了後に 7日間の Fail-safe 対象となる

DROP DATABASE IF EXISTS protection_verify_db;
