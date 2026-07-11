{% snapshot snap_customers %}

{{
    config(
        target_database='DBT_LEARN',
        target_schema='SNAPSHOTS',
        unique_key='customer_id',
        strategy='check',
        check_cols=['market_segment', 'account_balance']
    )
}}

select
    customer_id,
    customer_name,
    market_segment,
    account_balance,
    nation_id
from {{ ref('stg_customers')}}

{% endsnapshot %}