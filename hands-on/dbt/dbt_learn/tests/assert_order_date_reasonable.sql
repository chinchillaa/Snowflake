select
    order_id,
    order_date
from {{ref('stg_orders')}}
where order_date < '1990-01-01'
or order_date > CURRENT_DATE()