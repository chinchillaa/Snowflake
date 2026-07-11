-- ============================================================
-- 04_sentiment.sql
-- 対応まとめ: 06_Cortex_AI_ML.md § 6. SENTIMENT関数
-- 目的: 感情分析スコアの返り方を確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS cortex_verify_db;
USE DATABASE cortex_verify_db;
CREATE SCHEMA IF NOT EXISTS ai_lab;
USE SCHEMA ai_lab;

CREATE OR REPLACE TABLE feedback (
  feedback_id NUMBER,
  comment     STRING
);

INSERT INTO feedback VALUES
  (1, 'The dashboard is fast and easy to use.'),
  (2, 'The setup was confusing and the query took too long.'),
  (3, 'The feature works as expected.');

-- STEP 1: 感情分析
SELECT
  feedback_id,
  comment,
  SNOWFLAKE.CORTEX.SENTIMENT(comment) AS sentiment_score
FROM feedback
ORDER BY feedback_id;

-- STEP 2: スコアをラベル化
SELECT
  feedback_id,
  comment,
  SNOWFLAKE.CORTEX.SENTIMENT(comment) AS sentiment_score,
  CASE
    WHEN SNOWFLAKE.CORTEX.SENTIMENT(comment) >= 0.3 THEN 'POSITIVE'
    WHEN SNOWFLAKE.CORTEX.SENTIMENT(comment) <= -0.3 THEN 'NEGATIVE'
    ELSE 'NEUTRAL'
  END AS sentiment_label
FROM feedback
ORDER BY feedback_id;

DROP DATABASE IF EXISTS cortex_verify_db;
