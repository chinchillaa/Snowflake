-- ============================================================
-- 03_query_history.sql
-- 対応まとめ: 02_UI_Notebooks.md § 5. Query History / § 8.2 Activityメニュー
-- 目的: ACCOUNT_USAGE.QUERY_HISTORY で過去クエリの情報を確認する
-- 注意: ACCOUNT_USAGE はデータ反映に最大45分の遅延がある
--       直近のクエリは Monitoring → Query History（UI）で確認する方が速い
-- ============================================================

USE DATABASE SNOWFLAKE;
USE SCHEMA ACCOUNT_USAGE;

-- ============================================================
-- STEP 1: 過去24時間に自分が実行したクエリを確認
-- ============================================================
SELECT
    query_id,
    query_text,
    database_name,
    schema_name,
    execution_status,
    start_time,
    end_time,
    total_elapsed_time / 1000 AS elapsed_sec,
    bytes_scanned,
    rows_produced,
    warehouse_name
FROM query_history
WHERE user_name = CURRENT_USER()
  AND start_time >= DATEADD(HOUR, -24, CURRENT_TIMESTAMP())
ORDER BY start_time DESC
LIMIT 50;

-- ============================================================
-- STEP 2: 実行時間が長いクエリ TOP10（パフォーマンス調査）
-- ============================================================
SELECT
    query_id,
    LEFT(query_text, 100) AS query_snippet,
    total_elapsed_time / 1000 AS elapsed_sec,
    bytes_scanned / 1024 / 1024 AS mb_scanned,
    warehouse_name
FROM query_history
WHERE start_time >= DATEADD(DAY, -7, CURRENT_TIMESTAMP())
  AND execution_status = 'SUCCESS'
ORDER BY total_elapsed_time DESC
LIMIT 10;

-- ============================================================
-- STEP 3: エラーになったクエリの確認（障害調査）
-- ============================================================
SELECT
    query_id,
    user_name,
    LEFT(query_text, 200) AS query_snippet,
    error_code,
    error_message,
    start_time
FROM query_history
WHERE start_time >= DATEADD(DAY, -1, CURRENT_TIMESTAMP())
  AND execution_status = 'FAIL'
ORDER BY start_time DESC;

-- ============================================================
-- STEP 4: Warehouse別のクレジット消費確認
-- （METERING_HISTORY は QUERY_HISTORY とは別テーブル）
-- ============================================================
SELECT
    warehouse_name,
    SUM(credits_used)       AS total_credits,
    SUM(credits_used_compute) AS compute_credits,
    MIN(start_time)         AS first_used,
    MAX(end_time)           AS last_used
FROM metering_history
WHERE start_time >= DATEADD(DAY, -30, CURRENT_TIMESTAMP())
GROUP BY warehouse_name
ORDER BY total_credits DESC;
