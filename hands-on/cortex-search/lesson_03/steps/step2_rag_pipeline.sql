-- ============================================
-- Lesson 3 Step 3-6: RAG パイプライン実践
-- ============================================

-- 3-1: 検索だけで質問に答えてみる（RAG なし）
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'CORTEX_SEARCH_LEARN.SEARCH.KB_SEARCH',
    '{
      "query": "有給の申請方法を教えて",
      "columns": ["title", "content"],
      "limit": 2
    }'
  )
):results AS results;

-- 4-1: RAG パイプライン（検索 + LLM で回答生成）
WITH search_results AS (
  SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'CORTEX_SEARCH_LEARN.SEARCH.KB_SEARCH',
      '{
        "query": "有給休暇は何日前に申請すればいい？",
        "columns": ["title", "content"],
        "limit": 2
      }'
    )
  ):results AS results
),
context AS (
  SELECT ARRAY_TO_STRING(
    TRANSFORM(results, r -> r:content::STRING),
    '\n---\n'
  ) AS context_text
  FROM search_results
)
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'snowflake-arctic-instruct',
  CONCAT(
    'あなたは社内ヘルプデスクのアシスタントです。以下のドキュメントに基づいて質問に回答してください。',
    'ドキュメントに記載のない内容には「情報が見つかりません」と答えてください。\n\n',
    '【参考ドキュメント】\n', context_text, '\n\n',
    '【質問】有給休暇は何日前に申請すればいい？\n\n',
    '【回答】'
  )
) AS answer
FROM context;

-- 5-1: 経費に関する質問
WITH search_results AS (
  SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'CORTEX_SEARCH_LEARN.SEARCH.KB_SEARCH',
      '{
        "query": "経費精算の期限と承認ルール",
        "columns": ["title", "content"],
        "limit": 2
      }'
    )
  ):results AS results
),
context AS (
  SELECT ARRAY_TO_STRING(
    TRANSFORM(results, r -> r:content::STRING),
    '\n---\n'
  ) AS context_text
  FROM search_results
)
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'snowflake-arctic-instruct',
  CONCAT(
    'あなたは社内ヘルプデスクのアシスタントです。以下のドキュメントに基づいて質問に回答してください。',
    'ドキュメントに記載のない内容には「情報が見つかりません」と答えてください。\n\n',
    '【参考ドキュメント】\n', context_text, '\n\n',
    '【質問】経費精算の締め切りはいつ？高額な場合は誰の承認が必要？\n\n',
    '【回答】'
  )
) AS answer
FROM context;

-- 5-2: セキュリティに関する質問（部署フィルタ付き）
WITH search_results AS (
  SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'CORTEX_SEARCH_LEARN.SEARCH.KB_SEARCH',
      '{
        "query": "パソコンをなくした場合の対応",
        "columns": ["title", "content"],
        "filter": {"@eq": {"department": "セキュリティ"}},
        "limit": 2
      }'
    )
  ):results AS results
),
context AS (
  SELECT ARRAY_TO_STRING(
    TRANSFORM(results, r -> r:content::STRING),
    '\n---\n'
  ) AS context_text
  FROM search_results
)
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'snowflake-arctic-instruct',
  CONCAT(
    'あなたは社内ヘルプデスクのアシスタントです。以下のドキュメントに基づいて質問に回答してください。',
    'ドキュメントに記載のない内容には「情報が見つかりません」と答えてください。\n\n',
    '【参考ドキュメント】\n', context_text, '\n\n',
    '【質問】パソコンをなくしてしまいました。どうすればいいですか？\n\n',
    '【回答】'
  )
) AS answer
FROM context;

-- 6-1: ナレッジベースに存在しない情報を聞く
WITH search_results AS (
  SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'CORTEX_SEARCH_LEARN.SEARCH.KB_SEARCH',
      '{
        "query": "社員旅行の行き先",
        "columns": ["title", "content"],
        "limit": 2
      }'
    )
  ):results AS results
),
context AS (
  SELECT ARRAY_TO_STRING(
    TRANSFORM(results, r -> r:content::STRING),
    '\n---\n'
  ) AS context_text
  FROM search_results
)
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'snowflake-arctic-instruct',
  CONCAT(
    'あなたは社内ヘルプデスクのアシスタントです。以下のドキュメントに基づいて質問に回答してください。',
    'ドキュメントに記載のない内容には「情報が見つかりません」と答えてください。\n\n',
    '【参考ドキュメント】\n', context_text, '\n\n',
    '【質問】今年の社員旅行はどこに行きますか？\n\n',
    '【回答】'
  )
) AS answer
FROM context;
