SELECT
    r_regionkey AS region_id,
    r_name AS region_name,
    r_comment AS region_comment
FROM {{ source('tpch', 'region') }}
