{% set flags = ['R', 'A', 'N'] %}

SELECT
    o.customer_id,
    COUNT(*) AS total_line_items,
    {% for flag in flags %}
    COUNT(CASE WHEN li.return_flag = '{{ flag }}' THEN 1 END) AS flag_{{ flag }}_count,
    SUM(CASE WHEN li.return_flag = '{{ flag }}' THEN li.extended_price ELSE 0 END) AS flag_{{ flag }}_amount{% if not loop.last %},{% endif %}
    {% endfor %}
FROM {{ ref('stg_line_items') }} li
JOIN {{ ref('stg_orders') }} o ON li.order_id = o.order_id
GROUP BY o.customer_id
