-- ============================================================
-- 04_clustering.sql
-- 対応まとめ: 01_アーキテクチャ基礎.md § 6. クラスタリング
-- 目的: クラスタリングキーの設定・確認・解除を体験する
-- 注意: Automatic Clustering はサーバーレス課金が発生する。
--       実際の本番テーブルに設定する前に必ずコスト影響を確認すること。
-- ============================================================

-- ============================================================
-- STEP 1: 検証用テーブルの作成（サンプルデータからCTAS）
-- ============================================================
CREATE DATABASE IF NOT EXISTS verify_clustering_db;
USE DATABASE verify_clustering_db;
CREATE SCHEMA IF NOT EXISTS public;
USE SCHEMA public;

CREATE OR REPLACE TABLE verify_sales AS
SELECT
    o_orderdate          AS sale_date,
    o_orderpriority      AS region,
    o_totalprice         AS amount,
    o_custkey            AS customer_id
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.orders
LIMIT 100000;

-- ============================================================
-- STEP 2: クラスタリング設定前の状態確認
-- ============================================================
SELECT SYSTEM$CLUSTERING_INFORMATION('verify_sales');
-- → "average_overlaps" が高いほどクラスタリングが乱れている

-- ============================================================
-- STEP 3: クラスタリングキーを設定
-- ============================================================
ALTER TABLE verify_sales CLUSTER BY (sale_date);

-- ============================================================
-- STEP 4: クラスタリング状態を再確認
-- ============================================================
SELECT SYSTEM$CLUSTERING_INFORMATION('verify_sales', '(sale_date)');
-- 項目説明:
--   "cluster_by_keys"    : クラスタリングキー
--   "average_overlaps"   : 低いほど良い（0が理想）
--   "average_depth"      : 低いほど良い

-- SHOW TABLES でも CLUSTER_BY 列でキーを確認できる
SHOW TABLES LIKE 'VERIFY_SALES';

-- ============================================================
-- STEP 5: 複合クラスタリングキー（複数カラム）
-- ============================================================
ALTER TABLE verify_sales CLUSTER BY (region, sale_date);

SELECT SYSTEM$CLUSTERING_INFORMATION('verify_sales', '(region, sale_date)');

-- ============================================================
-- STEP 6: クラスタリングを解除
-- ============================================================
ALTER TABLE verify_sales DROP CLUSTERING KEY;

SHOW TABLES LIKE 'VERIFY_SALES';
-- → CLUSTER_BY 列が空になることを確認

-- ============================================================
-- STEP 7: 後片付け
-- ============================================================
DROP DATABASE IF EXISTS verify_clustering_db;
