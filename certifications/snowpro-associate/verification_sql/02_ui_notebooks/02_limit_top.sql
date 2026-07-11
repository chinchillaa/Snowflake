-- ============================================================
-- 02_limit_top.sql
-- 対応まとめ: 02_UI_Notebooks.md § 2.6 TOP / LIMIT による行数制限
-- 目的: LIMIT と TOP の等価性、ORDER BY なし時の非決定性を確認する
-- ============================================================

USE DATABASE SNOWFLAKE_SAMPLE_DATA;
USE SCHEMA TPCH_SF1;

-- ============================================================
-- STEP 1: LIMIT と TOP は同じ結果になることを確認
-- ============================================================
SELECT o_orderkey, o_totalprice FROM orders LIMIT 5;
SELECT TOP 5 o_orderkey, o_totalprice FROM orders;
-- → 同じ5行が返る（同一クエリなので Result Cache が利く）

-- ============================================================
-- STEP 2: ORDER BY なし LIMIT は非決定的（★試験頻出）
-- 複数回実行して行の順序が毎回変わる可能性があることを確認する
-- ============================================================
ALTER SESSION SET USE_CACHED_RESULT = FALSE;  -- キャッシュを無効化

-- 同じクエリを2回実行して、返ってくる行が変わることがある
SELECT o_orderkey FROM orders LIMIT 10;
SELECT o_orderkey FROM orders LIMIT 10;
-- → 行の順序が変わる場合がある（Warehouseが複数ノード持つほど顕著）

ALTER SESSION SET USE_CACHED_RESULT = TRUE;

-- ============================================================
-- STEP 3: ORDER BY を付けると結果が安定する（正しい使い方）
-- ============================================================
SELECT o_orderkey, o_totalprice
FROM orders
ORDER BY o_totalprice DESC
LIMIT 10;
-- → 常に "o_totalprice が最大の上位10行" が返る（決定的）

-- ============================================================
-- STEP 4: OFFSET との組み合わせ（ページング）
-- ============================================================
-- 1ページ目（1〜10行目）
SELECT o_orderkey, o_totalprice
FROM orders
ORDER BY o_orderkey
LIMIT 10 OFFSET 0;

-- 2ページ目（11〜20行目）
SELECT o_orderkey, o_totalprice
FROM orders
ORDER BY o_orderkey
LIMIT 10 OFFSET 10;
