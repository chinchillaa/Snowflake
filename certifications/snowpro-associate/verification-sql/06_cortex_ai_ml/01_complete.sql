-- ============================================================
-- 01_complete.sql
-- 対応まとめ: 06_Cortex_AI_ML.md § 3. COMPLETE関数
-- 目的: COMPLETE の基本呼び出し、テーブル連携、会話形式を確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS cortex_verify_db;
USE DATABASE cortex_verify_db;
CREATE SCHEMA IF NOT EXISTS ai_lab;
USE SCHEMA ai_lab;

CREATE OR REPLACE TABLE prompts (
  prompt_id NUMBER,
  category  STRING,
  prompt    STRING
);

INSERT INTO prompts VALUES
  (1, 'definition', 'Snowflakeの特徴を50文字以内で日本語説明'),
  (2, 'rewrite',    '次の文を丁寧語に変換: 期限までに対応して'),
  (3, 'summary',    'SQLとPythonの違いを2文で説明');

-- STEP 1: 単発プロンプト
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'claude-3-5-sonnet',
  'SnowflakeのVirtual Warehouseを1文で説明してください。'
) AS answer;

-- STEP 2: テーブルの列を使って一括生成
SELECT
  prompt_id,
  category,
  SNOWFLAKE.CORTEX.COMPLETE('claude-3-5-sonnet', prompt) AS generated_text
FROM prompts
ORDER BY prompt_id;

-- STEP 3: 会話形式
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'claude-3-5-sonnet',
  [
    OBJECT_CONSTRUCT('role', 'system', 'content', 'あなたはSnowflake講師です。'),
    OBJECT_CONSTRUCT('role', 'user', 'content', 'Warehouseとは何ですか？'),
    OBJECT_CONSTRUCT('role', 'assistant', 'content', 'クエリ実行用の計算資源です。'),
    OBJECT_CONSTRUCT('role', 'user', 'content', 'Auto Suspend も説明してください。')
  ]
) AS multi_turn_answer;

-- STEP 4: モデル一覧確認
SHOW CORTEX MODELS;

-- STEP 5: 後片付け
DROP DATABASE IF EXISTS cortex_verify_db;
