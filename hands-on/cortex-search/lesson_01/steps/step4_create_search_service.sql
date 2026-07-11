-- ============================================
-- Step 4: Cortex Search Service を作成する
-- ============================================

CREATE OR REPLACE CORTEX SEARCH SERVICE CORTEX_SEARCH_LEARN.SEARCH.FAQ_SEARCH
  ON answer
  ATTRIBUTES category
  WAREHOUSE = COMPUTE_WH
  TARGET_LAG = '1 hour'
AS (
  SELECT
      id,
      question,
      answer,
      category
  FROM CORTEX_SEARCH_LEARN.DATA.PRODUCT_FAQ
);
