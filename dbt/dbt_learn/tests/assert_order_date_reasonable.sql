SELECT
    order_id,
    order_date
FROM {{ ref('stg_orders') }}
WHERE order_date < '1990-01-01'
   OR order_date > CURRENT_DATE()
