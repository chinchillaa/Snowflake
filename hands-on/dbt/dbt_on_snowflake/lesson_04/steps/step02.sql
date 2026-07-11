-- 上位顧客を確認
SELECT customer_name, nation_name, total_orders, lifetime_value
FROM DBT_LEARN.ANALYTICS.DIM_CUSTOMERS
ORDER BY lifetime_value ASC
LIMIT 10;