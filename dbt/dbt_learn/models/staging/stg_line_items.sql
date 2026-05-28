SELECT
    l_orderkey AS order_id,
    l_linenumber AS line_number,
    l_partkey AS part_id,
    l_suppkey AS supplier_id,
    l_quantity AS quantity,
    l_extendedprice AS extended_price,
    l_discount AS discount,
    l_tax AS tax,
    l_returnflag AS return_flag,
    l_linestatus AS line_status,
    l_shipdate AS ship_date
FROM {{ source('tpch', 'lineitem') }}
