-- ============================================================
-- 01_external_table.sql
-- 対応まとめ: 09_高度なオブジェクト_データレイク.md § 1. 外部テーブル
-- 目的: 外部ステージと外部テーブルの定義を確認する
-- 注意: 実行にはクラウドストレージ連携済みの STAGE が必要
-- ============================================================

CREATE DATABASE IF NOT EXISTS advanced_obj_verify_db;
USE DATABASE advanced_obj_verify_db;
CREATE SCHEMA IF NOT EXISTS lake_lab;
USE SCHEMA lake_lab;

-- STEP 1: 外部ステージ例
-- CREATE OR REPLACE STAGE ext_parquet_stage
--   URL = 's3://my-bucket/path/'
--   STORAGE_INTEGRATION = my_s3_int
--   FILE_FORMAT = (TYPE = PARQUET);

-- STEP 2: 外部テーブル作成例
CREATE OR REPLACE EXTERNAL TABLE ext_sales (
  file_name STRING AS (METADATA$FILENAME::STRING),
  order_id  NUMBER AS (VALUE:order_id::NUMBER),
  region    STRING AS (VALUE:region::STRING),
  amount    NUMBER(10,2) AS (VALUE:amount::NUMBER(10,2))
)
LOCATION = @ext_parquet_stage
AUTO_REFRESH = FALSE
FILE_FORMAT = (TYPE = PARQUET);

SHOW EXTERNAL TABLES;
DESC EXTERNAL TABLE ext_sales;

DROP DATABASE IF EXISTS advanced_obj_verify_db;
