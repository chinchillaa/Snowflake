-- ============================================================
-- 08_metadata_columns.sql
-- 対応まとめ: 03_データ管理_ロード.md § 11. メタデータカラム
-- 目的: COPY INTO 時の METADATA$FILENAME / METADATA$FILE_ROW_NUMBER を確認する
-- 注意: ステージに実ファイルがないとMETADATA列は取得できない。
--       このファイルでは構文とテーブル定義の確認がメイン。
-- ============================================================

CREATE DATABASE IF NOT EXISTS verify_meta_db;
USE DATABASE verify_meta_db;
CREATE SCHEMA IF NOT EXISTS public;
USE SCHEMA public;
CREATE WAREHOUSE IF NOT EXISTS verify_wh WAREHOUSE_SIZE = 'X-SMALL' AUTO_SUSPEND = 60 AUTO_RESUME = TRUE;
USE WAREHOUSE verify_wh;

-- ============================================================
-- STEP 1: メタデータカラムを保持するロード先テーブルの設計
-- ============================================================
CREATE TABLE IF NOT EXISTS pipeline_logs (
  log_file_name    VARCHAR(500),    -- METADATA$FILENAME
  log_file_row_id  NUMBER,          -- METADATA$FILE_ROW_NUMBER
  load_time        TIMESTAMP_LTZ,   -- ロード時刻
  log_time         TIMESTAMP_NTZ,   -- ログ本体の時刻
  user_event       VARCHAR(200),    -- ログ本体のイベント
  user_login       VARCHAR(200),    -- ログ本体のユーザー
  ip_address       VARCHAR(100)     -- ログ本体のIP
);

-- ============================================================
-- STEP 2: COPY INTO で METADATA$FILENAME を使う構文
-- ※ ステージにファイルを置いてから実行する
-- ============================================================
/*
CREATE STAGE pipeline_stage;
CREATE FILE FORMAT ff_json TYPE = JSON;

COPY INTO pipeline_logs
FROM (
  SELECT
    METADATA$FILENAME           AS log_file_name,
    METADATA$FILE_ROW_NUMBER    AS log_file_row_id,
    CURRENT_TIMESTAMP(0)        AS load_time,
    $1:datetime_iso8601::TIMESTAMP_NTZ AS log_time,
    $1:user_event::STRING              AS user_event,
    $1:user_login::STRING              AS user_login,
    $1:ip_address::STRING              AS ip_address
  FROM @pipeline_stage
)
FILE_FORMAT = (FORMAT_NAME = ff_json);
*/

-- ============================================================
-- STEP 3: ロード後にメタデータを確認
-- どのファイルのどの行がロードされたかを追跡できる
-- ============================================================
-- ロードが完了したら以下で確認する
SELECT
  log_file_name,
  COUNT(*)       AS row_count,
  MIN(log_time)  AS earliest_log,
  MAX(log_time)  AS latest_log
FROM pipeline_logs
GROUP BY log_file_name
ORDER BY log_file_name;

-- ============================================================
-- STEP 4: 手動挿入でメタデータカラムの効果を確認（代替）
-- ステージがない場合の動作確認用
-- ============================================================
INSERT INTO pipeline_logs VALUES
('logs/game_2026_01_01.json',  1, CURRENT_TIMESTAMP(), '2026-01-01 10:00:00'::TIMESTAMP_NTZ, 'login',    'alice', '192.168.1.1'),
('logs/game_2026_01_01.json',  2, CURRENT_TIMESTAMP(), '2026-01-01 10:05:00'::TIMESTAMP_NTZ, 'purchase', 'alice', '192.168.1.1'),
('logs/game_2026_01_02.json',  1, CURRENT_TIMESTAMP(), '2026-01-02 09:00:00'::TIMESTAMP_NTZ, 'login',    'bob',   '10.0.0.5');

-- ファイル名・行番号がロードされていることを確認
SELECT log_file_name, log_file_row_id, user_login, user_event
FROM pipeline_logs
ORDER BY log_file_name, log_file_row_id;

-- ============================================================
-- STEP 5: 後片付け
-- ============================================================
DROP TABLE IF EXISTS pipeline_logs;
DROP DATABASE IF EXISTS verify_meta_db;
DROP WAREHOUSE IF EXISTS verify_wh;
