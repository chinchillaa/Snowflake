{% snapshot snap_customers_sim %}

{{
    config(
        target_database='DBT_LEARN',
        target_schema='SNAPSHOTS',
        unique_key='customer_id',
        strategy='check',
        check_cols=['market_segment', 'account_balance']
    )
}}

SELECT
    customer_id,
    customer_name,
    market_segment,
    account_balance,
    nation_id
from dbt_learn.analytics.customer_simulation

{% endsnapshot %}