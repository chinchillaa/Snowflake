-- ============================================================
-- 10_tasks.sql
-- 対応まとめ: 03_データ管理_ロード.md § 13. Snowflakeタスク
-- 目的: タスクの作成・実行・DAG 構築・停止・履歴確認を体験する
-- ============================================================

CREATE DATABASE IF NOT EXISTS verify_task_db;
USE DATABASE verify_task_db;
CREATE SCHEMA IF NOT EXISTS public;
USE SCHEMA public;
CREATE WAREHOUSE IF NOT EXISTS verify_wh WAREHOUSE_SIZE = 'X-SMALL' AUTO_SUSPEND = 60 AUTO_RESUME = TRUE;
USE WAREHOUSE verify_wh;

-- タスク実行権限を付与（ACCOUNTADMINまたはSYSADMINロールで実行）
-- GRANT EXECUTE TASK ON ACCOUNT TO ROLE SYSADMIN;

-- ============================================================
-- STEP 1: タスクで操作するテーブルを準備
-- ============================================================
CREATE TABLE raw_logs (
  id         INT AUTOINCREMENT,
  log_time   TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
  message    VARCHAR(200)
);

CREATE TABLE processed_logs (
  id         INT,
  log_time   TIMESTAMP_NTZ,
  message    VARCHAR(200),
  processed  BOOLEAN DEFAULT TRUE
);

-- ============================================================
-- STEP 2: 単純なタスクの作成（Warehouse 使用）
-- SCHEDULE は '1 minute' 〜 '11520 minute' の範囲
-- ============================================================
CREATE OR REPLACE TASK simple_task
  WAREHOUSE = verify_wh
  SCHEDULE  = '1 minute'
AS
  INSERT INTO processed_logs (id, log_time, message)
  SELECT id, log_time, message FROM raw_logs
  WHERE id NOT IN (SELECT id FROM processed_logs);

-- ============================================================
-- STEP 3: タスク一覧の確認（初期状態は SUSPENDED）
-- ============================================================
SHOW TASKS;
-- → STATE が 'suspended' になっていることを確認

-- ============================================================
-- STEP 4: タスクを手動実行（スケジュール待ち不要）
-- EXECUTE TASK には EXECUTE TASK 権限が必要
-- ============================================================
-- テストデータを挿入してから実行
INSERT INTO raw_logs (message) VALUES ('テストログ1'), ('テストログ2');

EXECUTE TASK simple_task;

-- 結果確認
SELECT * FROM processed_logs ORDER BY id;

-- ============================================================
-- STEP 5: サーバーレスタスク（USER_TASK_MANAGED）
-- 頻繁な小さいタスクには Warehouse を使わずこちらを推奨
-- ============================================================
CREATE OR REPLACE TASK serverless_task
  USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
  SCHEDULE = '1 minute'
AS
  INSERT INTO processed_logs (id, log_time, message)
  SELECT id, log_time, message FROM raw_logs
  WHERE id NOT IN (SELECT id FROM processed_logs);

SHOW TASKS;

-- ============================================================
-- STEP 6: DAG（依存タスク）の構築
-- ============================================================
CREATE TABLE enriched_logs (
  id       INT,
  log_time TIMESTAMP_NTZ,
  message  VARCHAR(200),
  label    VARCHAR(50)
);

-- ルートタスク（スケジュール付き）
CREATE OR REPLACE TASK root_task
  USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
  SCHEDULE = '5 minute'
AS
  INSERT INTO processed_logs (id, log_time, message)
  SELECT id, log_time, message FROM raw_logs
  WHERE id NOT IN (SELECT id FROM processed_logs);

-- 依存タスク（root_task 完了後に自動起動）
CREATE OR REPLACE TASK child_task
  USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
  AFTER root_task     -- ← DAG 依存関係
AS
  MERGE INTO enriched_logs e
  USING processed_logs p ON e.id = p.id
  WHEN NOT MATCHED THEN
    INSERT (id, log_time, message, label)
    VALUES (p.id, p.log_time, p.message, 'processed');

-- ============================================================
-- STEP 7: タスクの開始（依存タスクを先に RESUME する）
-- 注意: child_task を先に RESUME し、root_task を後に RESUME する
-- ============================================================
ALTER TASK child_task RESUME;
ALTER TASK root_task  RESUME;

SHOW TASKS;
-- → root_task の STATE が 'started'、child_task が 'started' になることを確認

-- ============================================================
-- STEP 8: タスクの停止
-- ============================================================
ALTER TASK root_task  SUSPEND;
ALTER TASK child_task SUSPEND;

-- ============================================================
-- STEP 9: タスク実行履歴の確認
-- ============================================================
SELECT *
FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY(
  TASK_NAME   => 'SIMPLE_TASK',
  RESULT_LIMIT => 10
))
ORDER BY scheduled_time DESC;

-- ============================================================
-- STEP 10: 後片付け
-- ============================================================
DROP TASK IF EXISTS child_task;
DROP TASK IF EXISTS root_task;
DROP TASK IF EXISTS serverless_task;
DROP TASK IF EXISTS simple_task;
DROP TABLE IF EXISTS enriched_logs;
DROP TABLE IF EXISTS processed_logs;
DROP TABLE IF EXISTS raw_logs;
DROP DATABASE IF EXISTS verify_task_db;
DROP WAREHOUSE IF EXISTS verify_wh;
