SELECT
    customer_id,
    lifetime_value
FROM {{ ref('dim_customers') }}
WHERE lifetime_value < 0
