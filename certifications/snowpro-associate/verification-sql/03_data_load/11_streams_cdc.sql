-- ============================================================
-- 11_streams_cdc.sql
-- 対応まとめ: 03_データ管理_ロード.md § 14. ストリームとCDC
-- 目的: Stream の作成・変更追跡・METADATA$ACTION・Task との連携を確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS verify_stream_db;
USE DATABASE verify_stream_db;
CREATE SCHEMA IF NOT EXISTS public;
USE SCHEMA public;
CREATE WAREHOUSE IF NOT EXISTS verify_wh WAREHOUSE_SIZE = 'X-SMALL' AUTO_SUSPEND = 60 AUTO_RESUME = TRUE;
USE WAREHOUSE verify_wh;

-- ============================================================
-- STEP 1: ソーステーブルと Stream の作成
-- ============================================================
CREATE TABLE source_data (
  id       INT,
  name     VARCHAR(100),
  score    NUMBER(5, 2)
);

-- Stream を作成（ソーステーブルの変更を追跡）
CREATE OR REPLACE STREAM source_stream
  ON TABLE source_data;

-- ============================================================
-- STEP 2: Stream の存在確認
-- ============================================================
SHOW STREAMS;

-- ============================================================
-- STEP 3: ターゲットテーブルを作成
-- ============================================================
CREATE TABLE target_data (
  id    INT,
  name  VARCHAR(100),
  score NUMBER(5, 2)
);

-- ============================================================
-- STEP 4: INSERT で変更を発生させ Stream に記録させる
-- ============================================================
INSERT INTO source_data VALUES (1, 'Alice', 95.0), (2, 'Bob', 80.5);

-- ============================================================
-- STEP 5: Stream から変更データを確認
-- METADATA$ACTION / METADATA$ISUPDATE / METADATA$ROW_ID に注目
-- ============================================================
SELECT
  id,
  name,
  score,
  METADATA$ACTION    AS action,     -- INSERT または DELETE
  METADATA$ISUPDATE  AS is_update,  -- UPDATE の場合 TRUE
  METADATA$ROW_ID    AS row_id
FROM source_stream;
-- → METADATA$ACTION = 'INSERT' の行が表示される

-- ============================================================
-- STEP 6: Stream に変更データがあるか確認
-- ============================================================
SELECT SYSTEM$STREAM_HAS_DATA('source_stream');
-- → TRUE（未消費の変更がある）

-- ============================================================
-- STEP 7: Stream を消費（ターゲットへ MERGE）
-- Stream は DML で消費される（SELECT だけでは消費されない）
-- ============================================================
MERGE INTO target_data t
USING (SELECT * FROM source_stream) s
ON t.id = s.id
WHEN MATCHED AND s.METADATA$ACTION = 'DELETE' THEN
  DELETE
WHEN MATCHED AND s.METADATA$ACTION = 'INSERT' THEN
  UPDATE SET t.name = s.name, t.score = s.score
WHEN NOT MATCHED AND s.METADATA$ACTION = 'INSERT' THEN
  INSERT (id, name, score) VALUES (s.id, s.name, s.score);

-- 消費後は Stream が空になる
SELECT SYSTEM$STREAM_HAS_DATA('source_stream');
-- → FALSE（消費済み）

SELECT * FROM target_data ORDER BY id;

-- ============================================================
-- STEP 8: UPDATE の追跡（DELETE + INSERT のペアで表現される）
-- ============================================================
UPDATE source_data SET score = 99.0 WHERE id = 1;

-- Stream の変更確認（UPDATE は DELETE + INSERT の2行で追跡される）
SELECT id, name, score, METADATA$ACTION, METADATA$ISUPDATE
FROM source_stream
ORDER BY id, METADATA$ACTION;
-- → id=1 が DELETE（ISUPDATE=TRUE）と INSERT（ISUPDATE=TRUE）の 2行

-- ============================================================
-- STEP 9: Task + Stream の組み合わせ（CDC パイプライン）
-- 変更があるときだけタスクを実行する
-- ============================================================
-- まず Stream を消費しておく
MERGE INTO target_data t
USING (SELECT * FROM source_stream) s
ON t.id = s.id
WHEN MATCHED AND s.METADATA$ACTION = 'DELETE' THEN DELETE
WHEN MATCHED AND s.METADATA$ACTION = 'INSERT' THEN
  UPDATE SET t.name = s.name, t.score = s.score
WHEN NOT MATCHED AND s.METADATA$ACTION = 'INSERT' THEN
  INSERT (id, name, score) VALUES (s.id, s.name, s.score);

-- CDC タスク（WHEN 句でストリームの有無を確認）
CREATE OR REPLACE TASK cdc_task
  USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
  SCHEDULE = '5 minute'
  WHEN SYSTEM$STREAM_HAS_DATA('source_stream')   -- ← 変更がある時だけ実行
AS
  MERGE INTO target_data t
  USING (SELECT * FROM source_stream) s
  ON t.id = s.id
  WHEN MATCHED AND s.METADATA$ACTION = 'DELETE' THEN DELETE
  WHEN MATCHED AND s.METADATA$ACTION = 'INSERT' THEN
    UPDATE SET t.name = s.name, t.score = s.score
  WHEN NOT MATCHED AND s.METADATA$ACTION = 'INSERT' THEN
    INSERT (id, name, score) VALUES (s.id, s.name, s.score);

SHOW TASKS;

-- ============================================================
-- STEP 10: 後片付け
-- ============================================================
ALTER TASK cdc_task SUSPEND;
DROP TASK IF EXISTS cdc_task;
DROP STREAM IF EXISTS source_stream;
DROP TABLE IF EXISTS target_data;
DROP TABLE IF EXISTS source_data;
DROP DATABASE IF EXISTS verify_stream_db;
DROP WAREHOUSE IF EXISTS verify_wh;
