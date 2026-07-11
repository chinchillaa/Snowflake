SELECT
    o.order_id,
    o.customer_id,
    c.customer_name,
    c.market_segment,
    n.nation_name,
    r.region_name,
    o.order_status,
    o.total_price,
    o.order_date,
    o.order_priority
FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ ref('stg_customers') }} c
    ON o.customer_id = c.customer_id
LEFT JOIN {{ ref('stg_nations') }} n
    ON c.nation_id = n.nation_id
LEFT JOIN {{ ref('stg_regions') }} r
    ON n.region_id = r.region_id
