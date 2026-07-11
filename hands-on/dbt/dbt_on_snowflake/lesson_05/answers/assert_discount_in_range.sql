SELECT
    order_id,
    line_number,
    discount
FROM {{ ref('stg_line_items') }}
WHERE discount < 0 OR discount > 1
