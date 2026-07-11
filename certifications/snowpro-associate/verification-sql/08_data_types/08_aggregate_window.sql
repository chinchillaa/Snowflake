-- ============================================================
-- 08_aggregate_window.sql
-- 対応まとめ: 08_データ型_SQL基礎.md § 6. 集計関数とウィンドウ関数
-- 目的: GROUP BY、RANK、移動集計を確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS sql_basics_verify_db;
USE DATABASE sql_basics_verify_db;
CREATE SCHEMA IF NOT EXISTS analytic_lab;
USE SCHEMA analytic_lab;

CREATE OR REPLACE TABLE monthly_sales (
  region STRING,
  sales_month DATE,
  amount NUMBER(10,2)
);

INSERT INTO monthly_sales VALUES
  ('JAPAN', '2026-01-01', 1000),
  ('JAPAN', '2026-02-01', 1200),
  ('APAC',  '2026-01-01', 1500),
  ('APAC',  '2026-02-01', 1300),
  ('EMEA',  '2026-01-01',  900);

SELECT region, SUM(amount) AS total_amount
FROM monthly_sales
GROUP BY region
ORDER BY total_amount DESC;

SELECT
  region,
  sales_month,
  amount,
  RANK() OVER (ORDER BY amount DESC) AS sales_rank,
  SUM(amount) OVER (
    PARTITION BY region
    ORDER BY sales_month
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_total
FROM monthly_sales
ORDER BY region, sales_month;

DROP DATABASE IF EXISTS sql_basics_verify_db;
