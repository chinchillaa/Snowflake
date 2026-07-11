-- hands-on/dbt/dbt_learn/models/marts/dim_customers.sql のクエリ
select
    c.customer_id,
    c.customer_name,
    c.market_segment,
    c.account_balance,
    n.nation_name,
    count(o.order_id) as totale_orders,
    sum(o.total_price) as lifetime_value,
    min(o.order_date) as first_order_date,
    max(o.order_date) as last_order_date
from {{ref('stg_customers')}} c
left join {{ref('stg_nations')}} n
    on c.nation_id = n.nation_id
left join {{ref('stg_orders')}} o
    on c.customer_id = o.customer_id
group by
    c.customer_id,
    c.customer_name,
    c.market_segment,
    c.account_balance,
    n.nation_name