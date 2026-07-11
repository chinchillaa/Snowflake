-- hands-on/dbt/dbt_learn/models/marts/fct_line_items.sqlのクエリ
{{
    config(
        materialized='incremental',
        unique_key=['order_id', 'line_number']
    )
}}

select
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
from {{ref('stg_line_items')}} li

{% if is_incremental() %}
where li.ship_date > (select max(ship_date) from {{ this }})
{% endif %}