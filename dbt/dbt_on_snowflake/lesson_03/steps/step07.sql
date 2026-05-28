-- dbt/dbt_learn/models/marts/fct_orders.sqlのクエリ
select
    o.order_id,
    o.customer_id,
    c.customer_name,
    c.market_segment,
    n.nation_name,
    o.order_status,
    o.total_price,
    o.order_date,
    o.order_priority    
from {{ref('stg_orders')}} o
left join {{ref('stg_customers')}} c
    on o.customer_id = c.customer_id
left join {{ref('stg_nations')}} n
    on c.nation_id = n.nation_id