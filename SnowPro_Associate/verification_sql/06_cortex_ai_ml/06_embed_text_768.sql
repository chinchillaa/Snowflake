-- ============================================================
-- 06_embed_text_768.sql
-- 対応まとめ: 06_Cortex_AI_ML.md § 8. EMBED_TEXT_768関数
-- 目的: テキスト埋め込みと類似度比較の流れを確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS cortex_verify_db;
USE DATABASE cortex_verify_db;
CREATE SCHEMA IF NOT EXISTS ai_lab;
USE SCHEMA ai_lab;

CREATE OR REPLACE TABLE kb_chunks (
  chunk_id NUMBER,
  content  STRING
);

INSERT INTO kb_chunks VALUES
  (1, 'SnowflakeのWarehouseは計算資源であり、ストレージとは独立してスケールする。'),
  (2, 'Time Travelは過去のある時点のデータ状態を参照する機能である。'),
  (3, 'Secure Data Sharingはデータをコピーせず他アカウントと共有する。');

-- STEP 1: 埋め込みベクトルを生成
SELECT
  chunk_id,
  SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', content) AS embedding
FROM kb_chunks
ORDER BY chunk_id;

-- STEP 2: 問い合わせ文との類似度比較
WITH query_vec AS (
  SELECT SNOWFLAKE.CORTEX.EMBED_TEXT_768(
    'snowflake-arctic-embed-m',
    '過去データを参照する機能は何ですか？'
  ) AS q
)
SELECT
  k.chunk_id,
  k.content,
  VECTOR_COSINE_SIMILARITY(
    SNOWFLAKE.CORTEX.EMBED_TEXT_768('snowflake-arctic-embed-m', k.content),
    q
  ) AS similarity
FROM kb_chunks k, query_vec
ORDER BY similarity DESC;

DROP DATABASE IF EXISTS cortex_verify_db;
