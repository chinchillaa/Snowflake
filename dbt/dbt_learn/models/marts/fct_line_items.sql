{{
    config(
        materialized='incremental',
        unique_key=['order_id', 'line_number']
    )
}}

SELECT
    li.order_id,
    li.line_number,
    li.part_id,
    li.supplier_id,
    li.quantity,
    li.extended_price,
    li.discount,
    li.tax,
    li.extended_price * (1 - li.discount) * (1 + li.tax) AS net_price,
    li.return_flag,
    li.line_status,
    li.ship_date
FROM {{ ref('stg_line_items') }} li

{% if is_incremental() %}
WHERE li.ship_date > (SELECT MAX(ship_date) FROM {{ this }})
{% endif %}
