-- ============================================
-- Lesson 2 Step 3-6: フィルタ検索の実践
-- ============================================

-- 3-1: フィルタなし検索（ベースライン）
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'CORTEX_SEARCH_LEARN.SEARCH.TECH_DOCS_SEARCH',
    '{
      "query": "セキュリティの設定方法",
      "columns": ["doc_id", "title", "category", "department"],
      "limit": 5
    }'
  )
):results AS results;

-- 4-1: category でフィルタ（security のみ）
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'CORTEX_SEARCH_LEARN.SEARCH.TECH_DOCS_SEARCH',
    '{
      "query": "セキュリティの設定方法",
      "columns": ["doc_id", "title", "content", "category"],
      "filter": {"@eq": {"category": "security"}},
      "limit": 5
    }'
  )
):results AS results;

-- 4-2: department でフィルタ（データサイエンスのみ）
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'CORTEX_SEARCH_LEARN.SEARCH.TECH_DOCS_SEARCH',
    '{
      "query": "機械学習やAIの機能",
      "columns": ["doc_id", "title", "content", "department"],
      "filter": {"@eq": {"department": "データサイエンス"}},
      "limit": 5
    }'
  )
):results AS results;

-- 5-1: AND フィルタ（beginner かつ development）
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'CORTEX_SEARCH_LEARN.SEARCH.TECH_DOCS_SEARCH',
    '{
      "query": "データ処理の基本",
      "columns": ["doc_id", "title", "difficulty", "category"],
      "filter": {"@and": [
        {"@eq": {"difficulty": "beginner"}},
        {"@eq": {"category": "development"}}
      ]},
      "limit": 5
    }'
  )
):results AS results;

-- 5-2: OR フィルタ（security または monitoring）
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'CORTEX_SEARCH_LEARN.SEARCH.TECH_DOCS_SEARCH',
    '{
      "query": "システムの安全性を保つ方法",
      "columns": ["doc_id", "title", "category", "department"],
      "filter": {"@or": [
        {"@eq": {"category": "security"}},
        {"@eq": {"category": "monitoring"}}
      ]},
      "limit": 5
    }'
  )
):results AS results;

-- 6-1: 返却カラムの制御（最小限）
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'CORTEX_SEARCH_LEARN.SEARCH.TECH_DOCS_SEARCH',
    '{
      "query": "コスト削減",
      "columns": ["doc_id", "title"],
      "limit": 3
    }'
  )
):results AS results;
