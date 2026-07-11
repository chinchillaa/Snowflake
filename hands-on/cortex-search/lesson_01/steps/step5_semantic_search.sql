-- ============================================
-- Step 5: セマンティック検索を体感する
-- ============================================

-- 5-1: 「商品を返したい」で検索（LIKE では 0件だった！）
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'CORTEX_SEARCH_LEARN.SEARCH.FAQ_SEARCH',
    '{
      "query": "商品を返したい",
      "columns": ["id", "question", "answer", "category"],
      "limit": 3
    }'
  )
):results AS results;

-- 5-2: 「届くまで何日かかる？」で検索
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'CORTEX_SEARCH_LEARN.SEARCH.FAQ_SEARCH',
    '{
      "query": "届くまで何日かかる？",
      "columns": ["id", "question", "answer"],
      "limit": 3
    }'
  )
):results AS results;

-- 5-3: 「お金の払い方」で検索
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'CORTEX_SEARCH_LEARN.SEARCH.FAQ_SEARCH',
    '{
      "query": "お金の払い方",
      "columns": ["id", "question", "answer"],
      "limit": 3
    }'
  )
):results AS results;
