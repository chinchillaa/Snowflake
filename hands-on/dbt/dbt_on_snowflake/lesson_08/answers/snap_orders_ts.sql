{% snapshot snap_orders_ts %}

{{
    config(
        target_database='DBT_LEARN',
        target_schema='SNAPSHOTS',
        unique_key='order_id',
        strategy='timestamp',
        updated_at='order_date'
    )
}}

SELECT
    order_id,
    customer_id,
    order_status,
    total_price,
    order_date
FROM {{ ref('stg_orders') }}

{% endsnapshot %}
