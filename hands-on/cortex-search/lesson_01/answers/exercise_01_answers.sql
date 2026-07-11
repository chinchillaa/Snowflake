-- ============================================
-- Lesson 1 演習 模範解答
-- ============================================

-- 問 1: 同義語での検索
-- 「返金してほしい」
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'CORTEX_SEARCH_LEARN.SEARCH.FAQ_SEARCH',
    '{"query": "返金してほしい", "columns": ["id", "question", "answer"], "limit": 3}'
  )
):results AS results;

-- 「お金を戻してほしい」
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'CORTEX_SEARCH_LEARN.SEARCH.FAQ_SEARCH',
    '{"query": "お金を戻してほしい", "columns": ["id", "question", "answer"], "limit": 3}'
  )
):results AS results;

-- 「リファンド」
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'CORTEX_SEARCH_LEARN.SEARCH.FAQ_SEARCH',
    '{"query": "リファンド", "columns": ["id", "question", "answer"], "limit": 3}'
  )
):results AS results;

-- 問 2: 曖昧な質問での検索
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'CORTEX_SEARCH_LEARN.SEARCH.FAQ_SEARCH',
    '{"query": "買ったものについて困っている", "columns": ["id", "question", "answer"], "limit": 3}'
  )
):results AS results;

-- 問 3: 英語での検索
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'CORTEX_SEARCH_LEARN.SEARCH.FAQ_SEARCH',
    '{"query": "How to return a product?", "columns": ["id", "question", "answer"], "limit": 3}'
  )
):results AS results;
