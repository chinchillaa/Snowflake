-- ============================================================
-- 05_extract_answer.sql
-- 対応まとめ: 06_Cortex_AI_ML.md § 7. EXTRACT_ANSWER関数
-- 目的: 文書から質問に対する回答を抽出する
-- ============================================================

CREATE DATABASE IF NOT EXISTS cortex_verify_db;
USE DATABASE cortex_verify_db;
CREATE SCHEMA IF NOT EXISTS ai_lab;
USE SCHEMA ai_lab;

CREATE OR REPLACE TABLE faq_docs (
  doc_id    NUMBER,
  document  STRING,
  question  STRING
);

INSERT INTO faq_docs VALUES
  (
    1,
    'Warehouseはクエリ実行用の計算資源です。AUTO_SUSPENDを設定すると、一定時間アイドル時に自動停止しコストを抑えられます。',
    'AUTO_SUSPENDの役割は何ですか？'
  ),
  (
    2,
    'Time Travelを使うと過去の時点のデータを参照できます。UNDROPを使えば削除済みテーブルも保持期間内なら復元できます。',
    '削除したテーブルを戻すには何を使いますか？'
  );

SELECT
  doc_id,
  question,
  SNOWFLAKE.CORTEX.EXTRACT_ANSWER(document, question) AS extracted_answer
FROM faq_docs
ORDER BY doc_id;

DROP DATABASE IF EXISTS cortex_verify_db;
