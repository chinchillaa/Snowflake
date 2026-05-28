SELECT
    n_nationkey AS nation_id,
    n_name AS nation_name,
    n_regionkey AS region_id
FROM {{ source('tpch', 'nation') }}
