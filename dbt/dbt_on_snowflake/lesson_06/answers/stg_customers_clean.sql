SELECT
    c_custkey AS customer_id,
    {{ clean_string('c_name') }} AS customer_name,
    c_nationkey AS nation_id,
    c_acctbal AS account_balance,
    {{ clean_string('c_mktsegment') }} AS market_segment
FROM {{ source('tpch', 'customer') }}
