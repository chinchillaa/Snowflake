-- ビューが作成されたことを確認
show views in schema dbt_learn.analytics;

-- 中身を確認（カラム名がリネームされている！）
select * from snowflake_sample_data.tpch_sf1.orders LIMIT 5;  -- 元テーブル
SELECT * FROM DBT_LEARN.ANALYTICS.STG_ORDERS LIMIT 5;  -- 変換後ビュー

-- 行数を確認
SELECT COUNT(*) AS row_count FROM DBT_LEARN.ANALYTICS.STG_ORDERS;
-- → 1,500,000 行