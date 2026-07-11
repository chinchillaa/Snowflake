-- ============================================================
-- 07_parse_document.sql
-- 対応まとめ: 06_Cortex_AI_ML.md § 9. PARSE_DOCUMENT関数
-- 目的: ステージ上ドキュメントの解析呼び出し例を確認する
-- 注意: 実行前に対象PDFを内部ステージへ PUT しておくこと
-- ============================================================

CREATE DATABASE IF NOT EXISTS cortex_verify_db;
USE DATABASE cortex_verify_db;
CREATE SCHEMA IF NOT EXISTS ai_lab;
USE SCHEMA ai_lab;

CREATE OR REPLACE STAGE docs_stage;

-- STEP 1: 事前準備例
-- PUT file:///tmp/sample.pdf @docs_stage AUTO_COMPRESS = FALSE;
-- LIST @docs_stage;

-- STEP 2: テキスト抽出モード
SELECT SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
  '@docs_stage/sample.pdf',
  OBJECT_CONSTRUCT('mode', 'TEXT')
) AS parsed_text;

-- STEP 3: レイアウト保持モード
SELECT SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
  '@docs_stage/sample.pdf',
  OBJECT_CONSTRUCT('mode', 'LAYOUT')
) AS parsed_layout;

DROP DATABASE IF EXISTS cortex_verify_db;
