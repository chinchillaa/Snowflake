{# {{ config(materialized='view') }} #}  -- view vs table の実行時間の違い検証
{{
    config(
        materialized='table',
        tags=['reporting', 'hourly'],
        pre_hook="INSERT INTO DBT_LEARN.ANALYTICS.DBT_RUN_LOG (model_name) VALUES ('agg_daily_orders')"
    )
}}
SELECT
    o.order_date,
    n.nation_name,
    c.market_segment,
    COUNT(o.order_id) AS order_count,
    SUM(o.total_price) AS daily_revenue,
    AVG(o.total_price) AS avg_order_value
FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ ref('stg_customers') }} c
    ON o.customer_id = c.customer_id
LEFT JOIN {{ ref('stg_nations') }} n
    ON c.nation_id = n.nation_id
GROUP BY
    o.order_date,
    n.nation_name,
    c.market_segment
