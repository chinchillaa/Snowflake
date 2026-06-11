-- SELECT customer_id, market_segment, account_balance,
--        dbt_valid_from, dbt_valid_to
-- FROM DBT_LEARN.SNAPSHOTS.SNAP_CUSTOMERS_SIM
-- WHERE customer_id IN (60001, 60002)
-- ORDER BY customer_id, dbt_valid_from;

SELECT *
FROM DBT_LEARN.SNAPSHOTS.SNAP_CUSTOMERS_SIM
WHERE customer_id IN (60001, 60002)
ORDER BY customer_id, dbt_valid_from;
