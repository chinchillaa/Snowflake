-- ============================================================
-- 08_forecast.sql
-- 対応まとめ: 06_Cortex_AI_ML.md § 10. ML関数（機械学習）
-- 目的: 時系列データに対する FORECAST の実行例を確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS cortex_verify_db;
USE DATABASE cortex_verify_db;
CREATE SCHEMA IF NOT EXISTS ai_lab;
USE SCHEMA ai_lab;

CREATE OR REPLACE TABLE monthly_sales (
  sales_month DATE,
  revenue     NUMBER(10,2)
);

INSERT INTO monthly_sales VALUES
  ('2025-01-01', 12000), ('2025-02-01', 12500), ('2025-03-01', 13100),
  ('2025-04-01', 12900), ('2025-05-01', 14000), ('2025-06-01', 14500),
  ('2025-07-01', 14900), ('2025-08-01', 15100), ('2025-09-01', 15500),
  ('2025-10-01', 16200), ('2025-11-01', 17000), ('2025-12-01', 17800);

-- STEP 1: 予測の実行
SELECT *
FROM TABLE(
  SNOWFLAKE.ML.FORECAST(
    INPUT_DATA => TABLE(monthly_sales),
    TIMESTAMP_COLNAME => 'SALES_MONTH',
    TARGET_COLNAME => 'REVENUE',
    FORECASTING_PERIODS => 3
  )
);

DROP DATABASE IF EXISTS cortex_verify_db;
