SELECT
    order_id,
    line_number,
    quantity
FROM {{ ref('stg_line_items') }}
WHERE quantity <= 0
