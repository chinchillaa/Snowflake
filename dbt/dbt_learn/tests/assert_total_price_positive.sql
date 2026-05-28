SELECT
    order_id,
    total_price
FROM {{ ref('stg_orders') }}
WHERE total_price <= 0
