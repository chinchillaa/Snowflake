-- dbt/dbt_learn/models/staging/stg_orders.sqlについて
-- ソーステーブル ORDERS を参照（source('tpch', 'orders')）
-- 暗号的なカラム名（o_orderkey）を意味のある名前（order_id）にリネーム
-- 必要なカラムだけ選択
select
    o_orderkey as order_id,
    o_custkey as cutomer_id,
    o_orderstatus as order_status,
    o_totalprice as total_price,
    o_orderdate AS order_date,
    o_orderpriority AS order_priority
from {{ source('tpch', 'orders')}}  -- source.ymlの['sources']['name'],['sources']['tables']['name'] 