-- -- dbt/dbt_learn/models/marts/agg_daily_orders.sqlのクエリ
-- SELECT
--     o.order_date,
--     n.nation_name,
--     c.market_segment,
--     COUNT(o.order_id) AS order_count,
--     SUM(o.total_price) AS daily_revenue,
--     AVG(o.total_price) AS avg_order_value
-- FROM {{ ref('stg_orders') }} o
-- LEFT JOIN {{ ref('stg_customers') }} c
--     ON o.customer_id = c.customer_id
-- LEFT JOIN {{ ref('stg_nations') }} n
--     ON c.nation_id = n.nation_id
-- GROUP BY
--     o.order_date,
--     n.nation_name,
--     c.market_segment

-- 日次トレンドを確認
SELECT order_date, SUM(daily_revenue) AS total_revenue
FROM DBT_LEARN.ANALYTICS.AGG_DAILY_ORDERS
WHERE order_date BETWEEN '1997-01-01' AND '1997-01-31'
GROUP BY order_date
ORDER BY order_date;