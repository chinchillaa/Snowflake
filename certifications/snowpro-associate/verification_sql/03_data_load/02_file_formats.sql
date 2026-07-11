-- ============================================================
-- 02_file_formats.sql
-- 対応まとめ: 03_データ管理_ロード.md § 3. ファイルフォーマット
-- 目的: 各種 File Format オブジェクトの作成・確認・削除を体験する
-- ============================================================

CREATE DATABASE IF NOT EXISTS verify_ff_db;
USE DATABASE verify_ff_db;
CREATE SCHEMA IF NOT EXISTS public;
USE SCHEMA public;

-- ============================================================
-- STEP 1: CSV フォーマットの作成（ヘッダー1行スキップ）
-- ============================================================
CREATE FILE FORMAT csv_standard
  TYPE             = CSV
  FIELD_DELIMITER  = ','
  SKIP_HEADER      = 1
  NULL_IF          = ('NULL', 'null', '')
  EMPTY_FIELD_AS_NULL = TRUE;

-- ============================================================
-- STEP 2: パイプ区切り CSV フォーマット
-- ============================================================
CREATE FILE FORMAT csv_pipe
  TYPE             = CSV
  FIELD_DELIMITER  = '|'
  SKIP_HEADER      = 1;

-- ============================================================
-- STEP 3: タブ区切り（TSV）フォーマット
-- ============================================================
CREATE FILE FORMAT tsv_format
  TYPE             = CSV
  FIELD_DELIMITER  = '\t'
  SKIP_HEADER      = 1;

-- ============================================================
-- STEP 4: JSON フォーマット（外側配列を除去）
-- ============================================================
CREATE FILE FORMAT json_format
  TYPE             = JSON
  STRIP_OUTER_ARRAY = TRUE;

-- ============================================================
-- STEP 5: Parquet フォーマット
-- ============================================================
CREATE FILE FORMAT parquet_format
  TYPE = PARQUET;

-- ============================================================
-- STEP 6: File Format 一覧の確認
-- TYPE, FIELD_DELIMITER, SKIP_HEADER 列に注目する
-- ============================================================
SHOW FILE FORMATS;

-- ============================================================
-- STEP 7: File Format の詳細確認
-- ============================================================
DESC FILE FORMAT csv_standard;

-- ============================================================
-- STEP 8: File Format の変更（ALTER）
-- ============================================================
ALTER FILE FORMAT csv_standard SET SKIP_HEADER = 0;
DESC FILE FORMAT csv_standard;   -- SKIP_HEADER が 0 に変わったことを確認

-- ============================================================
-- STEP 9: 後片付け
-- ============================================================
DROP FILE FORMAT IF EXISTS csv_standard;
DROP FILE FORMAT IF EXISTS csv_pipe;
DROP FILE FORMAT IF EXISTS tsv_format;
DROP FILE FORMAT IF EXISTS json_format;
DROP FILE FORMAT IF EXISTS parquet_format;
DROP DATABASE IF EXISTS verify_ff_db;
