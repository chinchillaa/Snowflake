SELECT customer_id, customer_name, market_segment, account_balance,
       dbt_valid_from, dbt_valid_to
FROM DBT_LEARN.SNAPSHOTS.SNAP_CUSTOMERS
ORDER BY customer_id
LIMIT 20;