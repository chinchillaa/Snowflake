-- テーブルとして作成されていることを確認
SHOW TABLES IN SCHEMA DBT_LEARN.ANALYTICS;

-- 中身を見る：顧客名・国名が結合されている
SELECT * FROM DBT_LEARN.ANALYTICS.FCT_ORDERS LIMIT 10;

-- 国別の売上ランキングを出してみる
SELECT
    nation_name,
    COUNT(*) AS order_count,
    ROUND(SUM(total_price), 2) AS total_revenue
FROM DBT_LEARN.ANALYTICS.FCT_ORDERS
GROUP BY nation_name
ORDER BY total_revenue DESC
LIMIT 5;