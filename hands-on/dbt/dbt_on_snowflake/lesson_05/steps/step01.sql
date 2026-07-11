-- これが0行を返す → テストPASS（NULLが無い = 品質OK）
SELECT order_id
FROM stg_orders
WHERE order_id IS NULL