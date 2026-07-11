SELECT
    o_orderkey AS order_id,
    o_custkey AS customer_id,
    o_orderstatus AS order_status,
    o_totalprice AS total_price,
    o_orderdate AS order_date,
    o_orderpriority AS order_priority
FROM {{ source('tpch', 'orders') }}
{# FROM {{ source('tpch', 'NONEXISTENT') }}  -- わざとエラーを起こしてみる実験 #}
