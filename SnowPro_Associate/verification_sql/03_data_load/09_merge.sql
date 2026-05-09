-- ============================================================
-- 09_merge.sql
-- 対応まとめ: 03_データ管理_ロード.md § 12. MERGE文（差分ロード）
-- 目的: WHEN MATCHED / WHEN NOT MATCHED の動作とべき等性を確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS verify_merge_db;
USE DATABASE verify_merge_db;
CREATE SCHEMA IF NOT EXISTS public;
USE SCHEMA public;
CREATE WAREHOUSE IF NOT EXISTS verify_wh WAREHOUSE_SIZE = 'X-SMALL' AUTO_SUSPEND = 60 AUTO_RESUME = TRUE;
USE WAREHOUSE verify_wh;

-- ============================================================
-- STEP 1: ターゲットテーブル（既存データ）
-- ============================================================
CREATE TABLE customers_target (
  customer_id  INT,
  name         VARCHAR(100),
  email        VARCHAR(200),
  region       VARCHAR(50),
  updated_at   TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

INSERT INTO customers_target (customer_id, name, email, region) VALUES
(1, '田中太郎',   'tanaka@example.com', 'APAC'),
(2, '佐藤花子',   'sato@example.com',   'EMEA'),
(3, '山田一郎',   'yamada@example.com', 'NA');

-- ============================================================
-- STEP 2: ソーステーブル（新規・更新データ）
-- ============================================================
CREATE TABLE customers_source (
  customer_id  INT,
  name         VARCHAR(100),
  email        VARCHAR(200),
  region       VARCHAR(50)
);

INSERT INTO customers_source VALUES
(2, '佐藤花子',    'sato_new@example.com', 'APAC'),  -- 既存: email と region が変更
(4, '鈴木次郎',   'suzuki@example.com',   'NA');     -- 新規

-- ============================================================
-- STEP 3: MERGE（アップサート = UPDATE + INSERT）
-- ============================================================
MERGE INTO customers_target t
USING customers_source s
ON t.customer_id = s.customer_id
WHEN MATCHED THEN
  UPDATE SET
    t.email      = s.email,
    t.region     = s.region,
    t.updated_at = CURRENT_TIMESTAMP()
WHEN NOT MATCHED THEN
  INSERT (customer_id, name, email, region)
  VALUES (s.customer_id, s.name, s.email, s.region);

-- 結果確認: id=2 の email/region が更新、id=4 が新規追加されていることを確認
SELECT * FROM customers_target ORDER BY customer_id;

-- ============================================================
-- STEP 4: べき等性の確認
-- 同じ MERGE を再実行しても結果が変わらないことを確認する
-- ============================================================
MERGE INTO customers_target t
USING customers_source s
ON t.customer_id = s.customer_id
WHEN MATCHED THEN
  UPDATE SET
    t.email      = s.email,
    t.region     = s.region,
    t.updated_at = CURRENT_TIMESTAMP()
WHEN NOT MATCHED THEN
  INSERT (customer_id, name, email, region)
  VALUES (s.customer_id, s.name, s.email, s.region);

-- 再実行後の件数（べき等 → 何回実行しても 4件のまま）
SELECT COUNT(*) AS row_count FROM customers_target;

-- ============================================================
-- STEP 5: INSERT のみ（WHEN NOT MATCHED だけ）
-- 既存行には一切触れず、新規行だけ追加するパターン
-- ============================================================
CREATE TABLE idempotent_log (
  event_id   INT,
  event_name VARCHAR(100),
  event_time TIMESTAMP_NTZ
);

-- 初回ロード
INSERT INTO idempotent_log VALUES
(1, 'login',    '2026-01-01 10:00:00'::TIMESTAMP_NTZ),
(2, 'purchase', '2026-01-01 10:05:00'::TIMESTAMP_NTZ);

-- ソース（新規2件 + 既存1件）
CREATE TABLE source_events (
  event_id   INT,
  event_name VARCHAR(100),
  event_time TIMESTAMP_NTZ
);
INSERT INTO source_events VALUES
(2, 'purchase', '2026-01-01 10:05:00'::TIMESTAMP_NTZ),  -- 既存 → スキップ
(3, 'logout',   '2026-01-01 10:10:00'::TIMESTAMP_NTZ),  -- 新規 → 追加
(4, 'login',    '2026-01-01 10:15:00'::TIMESTAMP_NTZ);  -- 新規 → 追加

-- Insert Merge（重複なしで新規のみ追加）
MERGE INTO idempotent_log t
USING source_events s
ON t.event_id = s.event_id
WHEN NOT MATCHED THEN
  INSERT (event_id, event_name, event_time)
  VALUES (s.event_id, s.event_name, s.event_time);

SELECT COUNT(*) AS total_rows FROM idempotent_log;  -- → 4件（重複なし）

-- 何度実行しても 4件のまま（べき等）
MERGE INTO idempotent_log t
USING source_events s
ON t.event_id = s.event_id
WHEN NOT MATCHED THEN
  INSERT (event_id, event_name, event_time)
  VALUES (s.event_id, s.event_name, s.event_time);

SELECT COUNT(*) AS total_rows FROM idempotent_log;  -- → 4件（変わらない）

-- ============================================================
-- STEP 6: 後片付け
-- ============================================================
DROP TABLE IF EXISTS customers_target;
DROP TABLE IF EXISTS customers_source;
DROP TABLE IF EXISTS idempotent_log;
DROP TABLE IF EXISTS source_events;
DROP DATABASE IF EXISTS verify_merge_db;
DROP WAREHOUSE IF EXISTS verify_wh;
