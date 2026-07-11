select
    order_id,
    customer_id,
    total_price,
    order_date
from {{ref('stg_orders')}}
where order_date >= '{{var("start_date", "1998-01-01" )}}'

order by order_date desc
{{ limit_in_dev(5000) }}