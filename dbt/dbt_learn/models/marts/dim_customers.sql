SELECT
    c.customer_id,
    c.customer_name,
    c.market_segment,
    c.account_balance,
    n.nation_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_price) AS lifetime_value,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS last_order_date
FROM {{ ref('stg_customers') }} c
LEFT JOIN {{ ref('stg_nations') }} n
    ON c.nation_id = n.nation_id
LEFT JOIN {{ ref('stg_orders') }} o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.market_segment,
    c.account_balance,
    n.nation_name
