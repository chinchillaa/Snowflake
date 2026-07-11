-- ============================================================
-- 02_summarize.sql
-- 対応まとめ: 06_Cortex_AI_ML.md § 4. SUMMARIZE関数
-- 目的: 長文テキストの要約を確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS cortex_verify_db;
USE DATABASE cortex_verify_db;
CREATE SCHEMA IF NOT EXISTS ai_lab;
USE SCHEMA ai_lab;

CREATE OR REPLACE TABLE articles (
  article_id NUMBER,
  body       STRING
);

INSERT INTO articles VALUES
  (1, 'Snowflakeはクラウドネイティブなデータプラットフォームであり、ストレージとコンピュートを分離している。Warehouseは独立してスケールでき、同じデータに複数チームが並行アクセスしても競合を抑えやすい。またTime TravelやZero-Copy Cloneにより運用性も高い。'),
  (2, 'Cortex AI Functionsを使うと、SQLから直接要約、翻訳、感情分析、分類などを行える。外部API連携やインフラ管理を減らしつつ、Snowflake内のデータに対してAI処理を適用できる。');

-- STEP 1: 単一テキストの要約
SELECT SNOWFLAKE.CORTEX.SUMMARIZE(body) AS summary
FROM articles
WHERE article_id = 1;

-- STEP 2: 複数行の要約
SELECT
  article_id,
  SNOWFLAKE.CORTEX.SUMMARIZE(body) AS summary
FROM articles
ORDER BY article_id;

-- STEP 3: 元文と要約の長さ比較
SELECT
  article_id,
  LENGTH(body) AS original_len,
  LENGTH(SNOWFLAKE.CORTEX.SUMMARIZE(body)) AS summarized_len
FROM articles;

DROP DATABASE IF EXISTS cortex_verify_db;
