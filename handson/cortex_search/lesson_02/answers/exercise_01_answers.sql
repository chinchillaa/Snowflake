-- ============================================
-- Lesson 2 演習 模範解答
-- ============================================

-- 問 1: ネストしたフィルタ
-- beginner かつ (infrastructure OR development)
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'CORTEX_SEARCH_LEARN.SEARCH.TECH_DOCS_SEARCH',
    '{
      "query": "Snowflake の基本機能",
      "columns": ["doc_id", "title", "category", "difficulty"],
      "filter": {"@and": [
        {"@eq": {"difficulty": "beginner"}},
        {"@or": [
          {"@eq": {"category": "infrastructure"}},
          {"@eq": {"category": "development"}}
        ]}
      ]},
      "limit": 5
    }'
  )
):results AS results;

-- 問 2: 部署フィルタあり
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'CORTEX_SEARCH_LEARN.SEARCH.TECH_DOCS_SEARCH',
    '{
      "query": "データの安全を守る仕組み",
      "columns": ["doc_id", "title", "department", "category"],
      "filter": {"@eq": {"department": "データガバナンス"}},
      "limit": 5
    }'
  )
):results AS results;

-- 問 2: フィルタなし（比較用）
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'CORTEX_SEARCH_LEARN.SEARCH.TECH_DOCS_SEARCH',
    '{
      "query": "データの安全を守る仕組み",
      "columns": ["doc_id", "title", "department", "category"],
      "limit": 5
    }'
  )
):results AS results;

-- 問 3: 設計の回答例
-- ON: 記事本文（content / body カラム）
-- ATTRIBUTES: department, author, tag
-- 理由: 本文が検索対象、部署・著者・タグはフィルタ条件として使いたいため
