-- dbt/dbt_learn/tests/assert_total_price_positive.sqlのクエリ
select
    order_id,
    total_price
from {{ref('stg_orders')}}
where total_price <= 0