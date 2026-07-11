-- 作成されたオブジェクト一覧
SELECT table_name, table_type
FROM DBT_LEARN.INFORMATION_SCHEMA.TABLES
WHERE table_schema = 'ANALYTICS'
ORDER BY table_type, table_name;