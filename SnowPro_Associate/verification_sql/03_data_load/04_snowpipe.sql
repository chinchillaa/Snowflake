-- ============================================================
-- 04_snowpipe.sql
-- 対応まとめ: 03_データ管理_ロード.md § 5. Snowpipe
-- 目的: Snowpipe の作成・状態確認・履歴確認を体験する
-- 注意: AUTO_INGEST は外部クラウドのイベント設定が必要なため、
--       このファイルでは PIPE の作成・確認コマンドのみ体験する
-- ============================================================

CREATE DATABASE IF NOT EXISTS verify_pipe_db;
USE DATABASE verify_pipe_db;
CREATE SCHEMA IF NOT EXISTS public;
USE SCHEMA public;

-- ============================================================
-- STEP 1: ロード先テーブルと外部ステージを用意
-- ============================================================
CREATE TABLE IF NOT EXISTS pipe_target (
  log_time  TIMESTAMP_NTZ,
  message   VARCHAR(500)
);

-- 外部ステージの定義例（実接続なし）
/*
CREATE STAGE my_external_stage
  URL                 = 's3://my-logs-bucket/incoming/'
  STORAGE_INTEGRATION = my_s3_integration;
*/

-- 内部ステージで代替
CREATE STAGE IF NOT EXISTS pipe_stage;

-- ============================================================
-- STEP 2: Snowpipe の作成
-- AUTO_INGEST = TRUE にするとクラウドイベントで自動起動
-- ============================================================
CREATE PIPE IF NOT EXISTS my_pipe
  AUTO_INGEST = FALSE     -- FALSE にすると手動呼び出し（REST API）のみ
  COMMENT     = '検証用 Snowpipe'
  AS
  COPY INTO pipe_target (log_time, message)
  FROM (
    SELECT $1::TIMESTAMP_NTZ, $2::VARCHAR(500)
    FROM @pipe_stage
  )
  FILE_FORMAT = (TYPE = CSV);

-- ============================================================
-- STEP 3: Pipe 一覧の確認
-- NAME, DEFINITION, OWNER 列に注目
-- ============================================================
SHOW PIPES;

-- ============================================================
-- STEP 4: Pipe の詳細確認
-- ============================================================
DESC PIPE my_pipe;

-- ============================================================
-- STEP 5: Pipe の状態確認（実行状況・エラー）
-- ============================================================
SELECT PARSE_JSON(SYSTEM$PIPE_STATUS('my_pipe'));
-- 返り値の主要フィールド:
--   executionState    : RUNNING / STOPPED / PAUSED 等
--   pendingFileCount  : 処理待ちファイル数
--   lastIngestedTimestamp : 最後にロードした時刻

-- ============================================================
-- STEP 6: ロード履歴の確認（INFORMATION_SCHEMA）
-- ============================================================
SELECT *
FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
  TABLE_NAME  => 'PIPE_TARGET',
  START_TIME  => DATEADD(HOURS, -24, CURRENT_TIMESTAMP())
));

-- ============================================================
-- STEP 7: Pipe の一時停止・再開（メンテナンス時など）
-- ============================================================
ALTER PIPE my_pipe SET PIPE_EXECUTION_PAUSED = TRUE;
-- → executionState が PAUSED になることを確認
SELECT PARSE_JSON(SYSTEM$PIPE_STATUS('my_pipe'));

ALTER PIPE my_pipe SET PIPE_EXECUTION_PAUSED = FALSE;

-- ============================================================
-- STEP 8: 後片付け
-- ============================================================
DROP PIPE IF EXISTS my_pipe;
DROP DATABASE IF EXISTS verify_pipe_db;
