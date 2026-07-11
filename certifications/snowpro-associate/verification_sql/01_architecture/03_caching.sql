-- ============================================================
-- 03_caching.sql
-- 対応まとめ: 01_アーキテクチャ基礎.md § 5. キャッシング
-- 目的: Result Cache の動作を Query History で確認する
-- 前提: Snowflakeのサンプルデータ（SNOWFLAKE_SAMPLE_DATA）を使用
-- ============================================================

-- ============================================================
-- STEP 1: サンプルデータのテーブルを確認
-- ============================================================
USE DATABASE SNOWFLAKE_SAMPLE_DATA;
USE SCHEMA TPCH_SF1;

SHOW TABLES;

-- ============================================================
-- STEP 2: 1回目のクエリ実行（ストレージから読み込む）
-- Query History で "duration" と "bytes_scanned" を確認する
-- ============================================================
SELECT
    l_returnflag,
    l_linestatus,
    SUM(l_quantity)    AS sum_qty,
    SUM(l_extendedprice) AS sum_base_price,
    COUNT(*)           AS count_order
FROM lineitem
WHERE l_shipdate <= DATEADD(DAY, -90, '1998-12-01')
GROUP BY l_returnflag, l_linestatus
ORDER BY l_returnflag, l_linestatus;

-- ============================================================
-- STEP 3: まったく同じクエリを再実行（Result Cache が使われる）
-- Query History の "bytes_scanned" が 0 になり、
-- "query_type" が "RESULT_REUSE" になることを確認する
-- ============================================================
SELECT
    l_returnflag,
    l_linestatus,
    SUM(l_quantity)    AS sum_qty,
    SUM(l_extendedprice) AS sum_base_price,
    COUNT(*)           AS count_order
FROM lineitem
WHERE l_shipdate <= DATEADD(DAY, -90, '1998-12-01')
GROUP BY l_returnflag, l_linestatus
ORDER BY l_returnflag, l_linestatus;

-- ============================================================
-- STEP 4: Result Cache を無効化して再実行（比較用）
-- ============================================================
ALTER SESSION SET USE_CACHED_RESULT = FALSE;

SELECT
    l_returnflag,
    l_linestatus,
    SUM(l_quantity)    AS sum_qty,
    SUM(l_extendedprice) AS sum_base_price,
    COUNT(*)           AS count_order
FROM lineitem
WHERE l_shipdate <= DATEADD(DAY, -90, '1998-12-01')
GROUP BY l_returnflag, l_linestatus
ORDER BY l_returnflag, l_linestatus;
-- → bytes_scanned が 0 にならず、実際にデータを読み込む

-- ============================================================
-- STEP 5: セッション設定をデフォルトに戻す
-- ============================================================
ALTER SESSION SET USE_CACHED_RESULT = TRUE;

-- ============================================================
-- STEP 6: Metadata Cache の確認
-- COUNT(*) はメタデータキャッシュから即座に返る（Warehouse 不要）
-- Query Profile で "TableScan" ノードの Partition Pruning を確認
-- ============================================================
SELECT COUNT(*) FROM lineitem;
-- → Warehouse が SUSPENDED でも実行できる（Metadata Cache）
