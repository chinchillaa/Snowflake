-- 2-1: 学習用データベースを作る（まだ無い場合）
CREATE DATABASE IF NOT EXISTS DBT_LEARN;
CREATE SCHEMA IF NOT EXISTS DBT_LEARN.ANALYTICS;

-- 2-2: 手動で変換ビューを作ってみる
create or replace view dbt_learn.analytics.v_orders_manual as
select
    o.o_orderkey as order_id,
    o.o_custkey as customer_id,
    c.c_name as customer_name,
    c.c_mktsegment as market_segment,
    n.n_name as nation_name,
    o.o_orderstatus as order_status,
    o.o_totalprice as total_price,
    o.o_orderdate as order_date
from snowflake_sample_data.tpch_sf1.orders o
left join snowflake_sample_data.tpch_sf1.customer c
    on o.o_custkey = c.c_custkey
left join snowflake_sample_data.tpch_sf1.nation n
    on c.c_nationkey = n.n_nationkey;

-- 2-3: 結果を確認
SELECT * FROM DBT_LEARN.ANALYTICS.V_ORDERS_MANUAL LIMIT 10;