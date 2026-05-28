-- 実行時間を確認（Query Profile で確認可能）
SELECT market_segment, SUM(daily_revenue) AS total
FROM DBT_LEARN.ANALYTICS.AGG_DAILY_ORDERS
GROUP BY market_segment;

-- 実行時間を直接確認
SET query_start = CURRENT_TIMESTAMP();

SELECT market_segment, SUM(daily_revenue) AS total
FROM DBT_LEARN.ANALYTICS.AGG_DAILY_ORDERS
GROUP BY market_segment;

SELECT DATEDIFF('millisecond', $query_start, CURRENT_TIMESTAMP()) AS execution_time_ms;