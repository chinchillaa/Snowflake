-- ============================================
-- Lesson 2 Step 2: 検索サービスを作成
-- ============================================

CREATE OR REPLACE CORTEX SEARCH SERVICE CORTEX_SEARCH_LEARN.SEARCH.TECH_DOCS_SEARCH
  ON content
  ATTRIBUTES category, department, difficulty
  WAREHOUSE = COMPUTE_WH
  TARGET_LAG = '1 hour'
AS (
  SELECT
      doc_id,
      title,
      content,
      category,
      department,
      difficulty,
      last_updated::VARCHAR AS last_updated
  FROM CORTEX_SEARCH_LEARN.DATA.TECH_DOCS
);
