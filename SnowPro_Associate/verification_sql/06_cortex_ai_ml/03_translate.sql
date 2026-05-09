-- ============================================================
-- 03_translate.sql
-- 対応まとめ: 06_Cortex_AI_ML.md § 5. TRANSLATE関数
-- 目的: TRANSLATE の基本動作を確認する
-- ============================================================

CREATE DATABASE IF NOT EXISTS cortex_verify_db;
USE DATABASE cortex_verify_db;
CREATE SCHEMA IF NOT EXISTS ai_lab;
USE SCHEMA ai_lab;

CREATE OR REPLACE TABLE messages (
  message_id NUMBER,
  source_lang STRING,
  target_lang STRING,
  message STRING
);

INSERT INTO messages VALUES
  (1, 'ja', 'en', 'Snowflakeはデータ共有をコピーなしで実現できます。'),
  (2, 'en', 'ja', 'Virtual warehouses can be resized independently from storage.'),
  (3, 'ja', 'ko', 'この文章を韓国語に翻訳してください。');

-- STEP 1: 単発翻訳
SELECT SNOWFLAKE.CORTEX.TRANSLATE(
  'Snowflake keeps data and compute separate.',
  'en',
  'ja'
) AS translated_text;

-- STEP 2: テーブルデータの翻訳
SELECT
  message_id,
  SNOWFLAKE.CORTEX.TRANSLATE(message, source_lang, target_lang) AS translated_text
FROM messages
ORDER BY message_id;

DROP DATABASE IF EXISTS cortex_verify_db;
