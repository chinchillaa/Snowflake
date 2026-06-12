-- ============================================
-- Lesson 3 演習 模範解答
-- ============================================

-- 問 1: 出典付き回答
WITH search_results AS (
  SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'CORTEX_SEARCH_LEARN.SEARCH.KB_SEARCH',
      '{
        "query": "リモートワークのルール",
        "columns": ["title", "content"],
        "limit": 2
      }'
    )
  ):results AS results
),
context AS (
  SELECT
    ARRAY_TO_STRING(TRANSFORM(results, r -> r:content::STRING), '\n---\n') AS context_text,
    ARRAY_TO_STRING(TRANSFORM(results, r -> r:title::STRING), ', ') AS titles
  FROM search_results
)
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'snowflake-arctic-instruct',
  CONCAT(
    'あなたは社内ヘルプデスクのアシスタントです。以下のドキュメントに基づいて質問に回答してください。',
    'ドキュメントに記載のない内容には「情報が見つかりません」と答えてください。',
    '回答の最後に「参考ドキュメント: [タイトル]」の形式で出典を記載してください。\n\n',
    '【参考ドキュメント】\n', context_text, '\n\n',
    '【ドキュメントタイトル】\n', titles, '\n\n',
    '【質問】リモートワークで気をつけることは？\n\n',
    '【回答】'
  )
) AS answer
FROM context;

-- 問 2-1: フィルタなし
WITH search_results AS (
  SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'CORTEX_SEARCH_LEARN.SEARCH.KB_SEARCH',
      '{
        "query": "新入社員が初日にやることとセキュリティで気をつけること",
        "columns": ["title", "content", "department"],
        "limit": 3
      }'
    )
  ):results AS results
),
context AS (
  SELECT ARRAY_TO_STRING(TRANSFORM(results, r -> r:content::STRING), '\n---\n') AS context_text
  FROM search_results
)
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'snowflake-arctic-instruct',
  CONCAT(
    'あなたは社内ヘルプデスクのアシスタントです。以下のドキュメントに基づいて質問に回答してください。\n\n',
    '【参考ドキュメント】\n', context_text, '\n\n',
    '【質問】新入社員が初日にやることと、セキュリティで気をつけることを教えて\n\n',
    '【回答】'
  )
) AS answer
FROM context;

-- 問 2-2: 人事フィルタあり（セキュリティ情報が欠落する）
WITH search_results AS (
  SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'CORTEX_SEARCH_LEARN.SEARCH.KB_SEARCH',
      '{
        "query": "新入社員が初日にやることとセキュリティで気をつけること",
        "columns": ["title", "content", "department"],
        "filter": {"@eq": {"department": "人事"}},
        "limit": 3
      }'
    )
  ):results AS results
),
context AS (
  SELECT ARRAY_TO_STRING(TRANSFORM(results, r -> r:content::STRING), '\n---\n') AS context_text
  FROM search_results
)
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'snowflake-arctic-instruct',
  CONCAT(
    'あなたは社内ヘルプデスクのアシスタントです。以下のドキュメントに基づいて質問に回答してください。\n\n',
    '【参考ドキュメント】\n', context_text, '\n\n',
    '【質問】新入社員が初日にやることと、セキュリティで気をつけることを教えて\n\n',
    '【回答】'
  )
) AS answer
FROM context;

-- 問 3: プロンプト改善版
WITH search_results AS (
  SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'CORTEX_SEARCH_LEARN.SEARCH.KB_SEARCH',
      '{
        "query": "リモートワークのルールを全部教えて",
        "columns": ["title", "content"],
        "limit": 2
      }'
    )
  ):results AS results
),
context AS (
  SELECT ARRAY_TO_STRING(TRANSFORM(results, r -> r:content::STRING), '\n---\n') AS context_text
  FROM search_results
)
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'snowflake-arctic-instruct',
  CONCAT(
    'あなたは社内ヘルプデスクのアシスタントです。以下のルールに従って回答してください：\n',
    '- 以下のドキュメントに基づいて質問に回答する\n',
    '- ドキュメントに記載のない内容には「情報が見つかりません」と答える\n',
    '- 回答は箇条書き形式で簡潔にまとめる\n',
    '- 回答の冒頭に確信度を記載する（高: ドキュメントに明記あり / 中: 推測を含む / 低: ほぼ情報なし）\n\n',
    '【参考ドキュメント】\n', context_text, '\n\n',
    '【質問】リモートワークのルールを全部教えて\n\n',
    '【回答】'
  )
) AS answer
FROM context;
