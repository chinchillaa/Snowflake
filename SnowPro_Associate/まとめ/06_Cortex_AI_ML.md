# Snowflake Cortex AI/ML

> SOL-C01 対応 | 出題比率: 15%
> ※ SOL-C01で新しく追加された重要ドメイン
> 最終更新: 2026年3月（Cortex AI Functions GA後）

---

## 1. Snowflake Cortex 概要

### 1.1 Cortexとは

**Snowflake Cortex**は、Snowflake内で直接AI/ML機能を利用できるサービスです。外部のAIサービスを使わずに、SQLから大規模言語モデル（LLM）やML機能を呼び出せます。

```
┌─────────────────────────────────────────────────────┐
│                    Snowflake                         │
│  ┌────────────────┐    ┌────────────────────────┐   │
│  │  Your Data     │ ──▶│   Snowflake Cortex     │   │
│  │  (テーブル)    │    │   ・LLM関数            │   │
│  └────────────────┘    │   ・ML関数             │   │
│                        │   ・Copilot            │   │
│                        └────────────────────────┘   │
│                                                      │
│  ★ データは Snowflake 内に留まる（外部送信なし）     │
└─────────────────────────────────────────────────────┘
```

### 1.2 なぜCortexを使うのか

| 従来の方法 | Cortexを使う場合 |
|-----------|-----------------|
| データを外部AIサービスに送信 | データはSnowflake内に留まる |
| APIキーの管理が必要 | SQLで直接呼び出し |
| 別途インフラ構築が必要 | Snowflakeが管理 |
| データ移動のコストと時間 | 即座に処理可能 |

### 1.3 主な特徴

| 特徴 | 説明 |
|------|------|
| **ネイティブ統合** | Snowflake内で完結、追加設定不要 |
| **セキュリティ** | データが外部に出ない |
| **SQL呼び出し** | 特別な知識不要、SQLで使える |
| **マネージド** | モデルの管理はSnowflakeが担当 |
| **スケーラブル** | 大量データに対しても実行可能 |

---

## 2. LLM関数（AI Functions）

### 2.1 LLMとは

**LLM（Large Language Model）** は、大量のテキストで学習した言語モデルです。テキスト生成、要約、翻訳、感情分析などができます。

### 2.2 利用可能な関数一覧

**テキスト処理関数**:

| 関数 | 説明 | 入力 | 出力 |
|------|------|------|------|
| **COMPLETE** | テキスト生成・質問応答 | プロンプト | 生成テキスト |
| **SUMMARIZE** | テキスト要約 | 長文テキスト | 要約文 |
| **TRANSLATE** | 翻訳 | テキスト + 言語コード | 翻訳文 |
| **SENTIMENT** | 感情分析 | テキスト | スコア（-1〜1） |
| **EXTRACT_ANSWER** | 文書から回答抽出 | 文書 + 質問 | 回答 |
| **EMBED_TEXT_768** | ベクトル埋め込み | テキスト | 768次元ベクトル |

**AI Functions（2025年11月 GA）**:

| 関数 | 説明 | 入力 | 出力 |
|------|------|------|------|
| **AI_CLASSIFY** | テキスト分類 | テキスト + カテゴリリスト | 分類結果 |
| **AI_TRANSLATE** | 高度な翻訳 | テキスト + 言語 | 翻訳文 |
| **AI_TRANSCRIBE** | 音声/動画の文字起こし | 音声/動画ファイル | テキスト |
| **AI_EXTRACT** | 構造化データ抽出 | テキスト + スキーマ | JSON |

> **マルチモーダル対応**: Cortex AI Functionsは、テキストだけでなく**画像、音声、動画**も処理可能になりました。

### 2.3 関数の呼び出し方

すべてのCortex関数は `SNOWFLAKE.CORTEX` スキーマにあります。

```sql
-- 基本的な呼び出し形式
SELECT SNOWFLAKE.CORTEX.関数名(引数);

-- 例: 感情分析
SELECT SNOWFLAKE.CORTEX.SENTIMENT('This product is amazing!');
-- 結果: 0.85（ポジティブ）
```

---

## 3. COMPLETE関数

> 🔗 **検証SQL**: [`verification/06_cortex_ai_ml/01_complete.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/06_cortex_ai_ml/01_complete.sql)

### 3.1 COMPLETEとは

プロンプト（指示文）に対してテキストを生成する関数です。質問応答、文章作成、要約など幅広く使えます。

### 3.2 基本構文

```sql
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'モデル名',    -- 使用するLLMモデル
  'プロンプト'   -- AIへの指示・質問
);
```

### 3.3 利用可能なモデル（2026年3月時点）

Snowflake Cortexでは、複数のプロバイダーから最新のLLMモデルを利用できます。

**主要モデル一覧**:

| モデル | 提供元 | 特徴 |
|--------|--------|------|
| `claude-opus-4.6` | Anthropic | 最高性能、複雑なタスクに最適 |
| `claude-3.5-sonnet` | Anthropic | 高性能、バランスの良いモデル |
| `gpt-5.2` | OpenAI | 最新のGPTモデル |
| `llama4-maverick` | Meta | 17B active / 400B total、画像理解・創作向け |
| `llama4-scout` | Meta | 17B active / 109B total、1000万トークンコンテキスト |
| `snowflake-llama-3.3-70b` | Snowflake | SwiftKV搭載、コスト75%削減 |
| `snowflake-llama-3.1-405b` | Snowflake | 超大規模、SwiftKV搭載 |
| `snowflake-arctic` | Snowflake | Snowflake独自モデル |
| `mistral-large` | Mistral AI | 高性能、多言語対応 |

> **Note**: 利用可能なモデルは随時追加されます。最新のリストは`SHOW CORTEX MODELS`で確認できます。

**モデル選択のガイドライン**:
- **高精度が必要**: `claude-opus-4.6`、`gpt-5.2`
- **コスト効率重視**: `snowflake-llama-3.3-70b`（SwiftKV）
- **大量コンテキスト**: `llama4-scout`（1000万トークン対応）
- **画像理解**: `llama4-maverick`（マルチモーダル対応）

### 3.4 使用例

```sql
-- 基本的な質問応答（Claude Opus 4.6を使用）
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'claude-opus-4.6',
  'Snowflakeとは何ですか？日本語で簡潔に説明してください。'
);
-- 結果: Snowflakeは、クラウドベースのデータウェアハウス...

-- コスト効率を重視する場合（SwiftKV搭載モデル）
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'snowflake-llama-3.3-70b',
  'この製品の説明を50文字以内で作成: ' || product_description
);

-- テーブルデータと組み合わせ
SELECT
  product_name,
  SNOWFLAKE.CORTEX.COMPLETE(
    'mistral-large',
    'この製品の説明を50文字以内で作成: ' || product_description
  ) AS short_description
FROM products;
```

### 3.5 会話形式（マルチターン）

複数のやり取りを含む会話も可能です。

```sql
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'claude-opus-4.6',
  [
    {'role': 'system', 'content': 'あなたはデータ分析の専門家です。'},
    {'role': 'user', 'content': 'SQLとは何ですか？'},
    {'role': 'assistant', 'content': 'SQLはデータベースを操作するための言語です。'},
    {'role': 'user', 'content': 'もう少し詳しく教えてください。'}
  ]
);
```

**ロールの意味**:
- `system`: AIの振る舞いを指定
- `user`: ユーザーからの質問
- `assistant`: AIの過去の回答

---

## 4. SUMMARIZE関数

> 🔗 **検証SQL**: [`verification/06_cortex_ai_ml/02_summarize.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/06_cortex_ai_ml/02_summarize.sql)

### 4.1 SUMMARIZEとは

長いテキストを短く要約する関数です。

### 4.2 基本構文

```sql
SELECT SNOWFLAKE.CORTEX.SUMMARIZE(テキスト);
```

### 4.3 使用例

```sql
-- 単純な要約
SELECT SNOWFLAKE.CORTEX.SUMMARIZE(
  'Snowflake is a cloud-based data warehousing platform that allows
   companies to store and analyze data using cloud-based hardware
   and software. Founded in 2012, Snowflake has revolutionized the
   way organizations handle big data...'
);

-- テーブルの長文カラムを要約
SELECT
  article_id,
  SNOWFLAKE.CORTEX.SUMMARIZE(article_body) AS summary
FROM articles;
```

### 4.4 実際の使用シーン

- **ニュース記事の要約**: 長い記事を短く
- **レポート要約**: 分析レポートのサマリー作成
- **顧客フィードバック**: 長いコメントを簡潔に

---

## 5. TRANSLATE関数

> 🔗 **検証SQL**: [`verification/06_cortex_ai_ml/03_translate.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/06_cortex_ai_ml/03_translate.sql)

### 5.1 TRANSLATEとは

テキストを別の言語に翻訳する関数です。

### 5.2 基本構文

```sql
SELECT SNOWFLAKE.CORTEX.TRANSLATE(
  テキスト,
  'ソース言語コード',
  'ターゲット言語コード'
);
```

### 5.3 言語コード

| コード | 言語 |
|--------|------|
| `en` | 英語 |
| `ja` | 日本語 |
| `de` | ドイツ語 |
| `fr` | フランス語 |
| `es` | スペイン語 |
| `ko` | 韓国語 |
| `zh` | 中国語 |

### 5.4 使用例

```sql
-- 英語から日本語に翻訳
SELECT SNOWFLAKE.CORTEX.TRANSLATE(
  'Hello, how are you?',
  'en',
  'ja'
);
-- 結果: こんにちは、お元気ですか？

-- テーブルデータの翻訳
SELECT
  product_name,
  SNOWFLAKE.CORTEX.TRANSLATE(description, 'en', 'ja') AS description_ja
FROM products;
```

### 5.5 実際の使用シーン

- **多言語対応**: 製品説明を複数言語に
- **グローバルデータ統合**: 各国のデータを共通言語に
- **顧客コミュニケーション**: 国際的な顧客対応

---

## 6. SENTIMENT関数

> 🔗 **検証SQL**: [`verification/06_cortex_ai_ml/04_sentiment.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/06_cortex_ai_ml/04_sentiment.sql)

### 6.1 SENTIMENTとは

テキストの**感情（ポジティブ/ネガティブ）** を数値で評価する関数です。

### 6.2 基本構文

```sql
SELECT SNOWFLAKE.CORTEX.SENTIMENT(テキスト);
```

### 6.3 戻り値の解釈

スコアは **-1.0 から 1.0** の範囲です。

| スコア範囲 | 意味 | 例 |
|-----------|------|-----|
| -1.0 〜 -0.5 | 非常にネガティブ | 「最悪のサービスだ」 |
| -0.5 〜 0 | ややネガティブ | 「期待はずれだった」 |
| 0 | ニュートラル | 「普通です」 |
| 0 〜 0.5 | ややポジティブ | 「まあまあ良い」 |
| 0.5 〜 1.0 | 非常にポジティブ | 「素晴らしい！」 |

### 6.4 使用例

```sql
-- 単純な感情分析
SELECT SNOWFLAKE.CORTEX.SENTIMENT('This product is fantastic!');
-- 結果: 0.85（ポジティブ）

SELECT SNOWFLAKE.CORTEX.SENTIMENT('Very disappointed with the service.');
-- 結果: -0.75（ネガティブ）

-- レビュー分析（ラベル付け）
SELECT
  review_id,
  review_text,
  SNOWFLAKE.CORTEX.SENTIMENT(review_text) AS sentiment_score,
  CASE
    WHEN SNOWFLAKE.CORTEX.SENTIMENT(review_text) > 0.3 THEN 'Positive'
    WHEN SNOWFLAKE.CORTEX.SENTIMENT(review_text) < -0.3 THEN 'Negative'
    ELSE 'Neutral'
  END AS sentiment_label
FROM reviews;
```

### 6.5 実際の使用シーン

- **顧客レビュー分析**: 商品の評判を数値化
- **SNSモニタリング**: ブランドへの反応を測定
- **カスタマーサポート**: 不満を持つ顧客を早期発見

---

## 7. EXTRACT_ANSWER関数

> 🔗 **検証SQL**: [`verification/06_cortex_ai_ml/05_extract_answer.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/06_cortex_ai_ml/05_extract_answer.sql)

### 7.1 EXTRACT_ANSWERとは

文書から特定の質問に対する回答を抽出する関数です。

### 7.2 基本構文

```sql
SELECT SNOWFLAKE.CORTEX.EXTRACT_ANSWER(
  ソーステキスト,  -- 回答が含まれている文書
  質問              -- 抽出したい情報
);
```

### 7.3 使用例

```sql
-- 文書から情報を抽出
SELECT SNOWFLAKE.CORTEX.EXTRACT_ANSWER(
  'Snowflake was founded in 2012. The company went public in 2020.',
  'When was Snowflake founded?'
);
-- 結果: {"answer": "2012", ...}

-- FAQ検索に活用
SELECT
  doc_id,
  SNOWFLAKE.CORTEX.EXTRACT_ANSWER(
    content,
    '返品ポリシーは何ですか？'
  ) AS answer
FROM documents
WHERE category = 'FAQ';
```

### 7.4 実際の使用シーン

- **FAQ検索**: 質問に対する回答を自動抽出
- **契約書分析**: 特定条項の内容を抽出
- **マニュアル検索**: 手順書から必要な情報を取得

---

## 8. EMBED_TEXT_768関数

> 🔗 **検証SQL**: [`verification/06_cortex_ai_ml/06_embed_text_768.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/06_cortex_ai_ml/06_embed_text_768.sql)

### 8.1 ベクトル埋め込みとは

テキストを**数値のベクトル（配列）** に変換する技術です。意味的に似たテキストは、ベクトル空間上で近い位置になります。

```
「犬」 → [0.23, 0.45, 0.12, ...]
「猫」 → [0.25, 0.43, 0.14, ...]  ← 犬に近い（ペット）
「車」 → [0.78, 0.11, 0.56, ...]  ← 犬から遠い
```

### 8.2 基本構文

```sql
SELECT SNOWFLAKE.CORTEX.EMBED_TEXT_768(
  'モデル名',
  テキスト
);
-- 768次元のベクトル（配列）を返す
```

### 8.3 使用例

```sql
-- テキストの埋め込みを取得
SELECT SNOWFLAKE.CORTEX.EMBED_TEXT_768(
  'e5-base-v2',
  'Snowflake is a cloud data platform.'
);

-- 埋め込みをテーブルに保存（後で検索に使用）
CREATE TABLE document_embeddings AS
SELECT
  doc_id,
  content,
  SNOWFLAKE.CORTEX.EMBED_TEXT_768('e5-base-v2', content) AS embedding
FROM documents;
```

### 8.4 類似度検索

ベクトルを使って「意味的に似た」ドキュメントを検索できます。

```sql
-- 検索クエリのベクトルを作成
WITH search_embedding AS (
  SELECT SNOWFLAKE.CORTEX.EMBED_TEXT_768(
    'e5-base-v2',
    '検索クエリテキスト'
  ) AS embedding
)
-- コサイン類似度で検索
SELECT
  d.doc_id,
  d.content,
  VECTOR_COSINE_SIMILARITY(d.embedding, s.embedding) AS similarity
FROM document_embeddings d, search_embedding s
ORDER BY similarity DESC
LIMIT 10;
```

### 8.5 実際の使用シーン

- **意味検索**: キーワード一致ではなく意味で検索
- **レコメンデーション**: 似た商品・コンテンツを推薦
- **重複検出**: 意味的に重複したデータを発見

---

## 9. PARSE_DOCUMENT関数

> 🔗 **検証SQL**: [`verification/06_cortex_ai_ml/07_parse_document.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/06_cortex_ai_ml/07_parse_document.sql)

### 9.1 PARSE_DOCUMENTとは

**PDFや画像ファイルなどのドキュメントからテキストを抽出する**Cortex AI関数です。

> **なぜ必要か？**
> PDFや画像のファイルは、通常のSQLではテキストとして読み取れません。PARSE_DOCUMENT関数を使うと、Snowflake内に保存したPDFなどから文字データを取り出し、そのままSQLで処理できます。

### 9.2 基本構文

```sql
SELECT SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
  @ステージ名,       -- ファイルが置かれているステージ
  'ファイルパス',    -- 対象ファイルのパス
  {'mode': 'LAYOUT'}  -- オプション（LAYOUT または OCR）
);
```

### 9.3 モードの違い

| モード | 説明 | 適した用途 |
|--------|------|----------|
| `LAYOUT` | テキストレイアウト（見出し・段落など）を保持して抽出 | 構造化されたPDF文書 |
| `OCR` | 画像内の文字を光学的に読み取る（OCR処理） | スキャンした紙の文書、画像ファイル |

> **OCR（Optical Character Recognition）とは？**
> スキャンした紙や写真の中に含まれる文字を、コンピュータが認識できるデジタルテキストに変換する技術です。

### 9.4 使用例

```sql
-- ステージにある請求書PDFからテキストを抽出
SELECT SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
  @my_documents_stage,
  'invoices/invoice_001.pdf',
  {'mode': 'LAYOUT'}
) AS extracted_text;

-- 抽出したテキストをさらにCOMPLETEで分析
SELECT
  file_name,
  SNOWFLAKE.CORTEX.COMPLETE(
    'claude-opus-4.6',
    '以下の請求書から合計金額を抽出してください: ' ||
    SNOWFLAKE.CORTEX.PARSE_DOCUMENT(
      @my_stage,
      file_name,
      {'mode': 'LAYOUT'}
    )::STRING
  ) AS total_amount
FROM invoice_files;
```

### 9.5 実際の使用シーン

| シーン | 具体例 |
|--------|--------|
| **請求書処理** | PDFの請求書から金額・日付を自動抽出 |
| **契約書分析** | 大量の契約書PDFから特定条項を検索 |
| **マニュアル検索** | 製品マニュアルPDFをテキスト化して全文検索 |
| **古い文書のデジタル化** | スキャンした紙の文書をOCRでテキスト化 |

---

## 10. ML関数（機械学習）

> 🔗 **検証SQL**: [`verification/06_cortex_ai_ml/08_forecast.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/06_cortex_ai_ml/08_forecast.sql)

### 9.1 ML関数とは

LLM以外の機械学習機能です。時系列予測や異常検知などができます。

### 9.2 利用可能な機能

| 関数 | 説明 | 用途 |
|------|------|------|
| **FORECAST** | 時系列予測 | 売上予測、需要予測 |
| **ANOMALY_DETECTION** | 異常検知 | 不正検出、障害予測 |
| **CLASSIFICATION** | 分類 | カテゴリ分け |
| **REGRESSION** | 回帰分析 | 数値予測 |

### 9.3 FORECAST使用例

```sql
-- 予測モデルの作成
CREATE SNOWFLAKE.ML.FORECAST my_forecast_model(
  INPUT_DATA =>
    SELECT date, sales FROM historical_sales,
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales'
);

-- 30日間の予測を実行
CALL my_forecast_model!FORECAST(
  FORECASTING_PERIODS => 30
);
```

### 9.4 実際の使用シーン

- **売上予測**: 来月の売上を予測
- **在庫管理**: 需要予測に基づく発注
- **異常検知**: 通常と異なるパターンを検出

---

## 11. Snowflake Copilot

### 10.1 Copilotとは

**自然言語**でデータを探索できるアシスタント機能です。質問を入力すると、SQLを自動生成してくれます。

### 10.2 機能

| 機能 | 説明 |
|------|------|
| **質問応答** | 「昨月の売上は？」などの質問に回答 |
| **SQL生成** | 質問からSQLを自動作成 |
| **クエリ説明** | SQLの動作を説明 |

### 10.3 使用イメージ（Snowsight内）

```
ユーザー: 「昨月の売上トップ10の製品を教えて」

Copilot:
SELECT product_name, SUM(amount) as total_sales
FROM sales
WHERE sale_date >= DATEADD(month, -1, CURRENT_DATE())
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;
```

### 10.4 利点

- **SQL不要**: 自然言語で質問できる
- **学習コスト低**: 非技術者でもデータ分析可能
- **生産性向上**: クエリ作成時間の短縮

---

## 12. セキュリティとガバナンス

### 11.1 データプライバシー

Cortexの重要な特徴は**データがSnowflake内に留まる**ことです。

```
従来のAI利用:
ユーザー → データを送信 → 外部AIサービス → 結果を受信
           ↑ セキュリティリスク

Cortex利用:
ユーザー → Snowflake内でAI処理 → 結果を取得
           ↑ データは外に出ない
```

### 11.2 アクセス制御

- 既存のロールベースアクセス制御（RBAC）が適用される
- Cortex関数もロールの権限で制御可能

### 11.3 コスト管理

Cortex関数は**クレジット消費**に基づく課金です。

```sql
-- Cortex使用量の確認
SELECT *
FROM SNOWFLAKE.ACCOUNT_USAGE.METERING_HISTORY
WHERE SERVICE_TYPE = 'CORTEX';
```

**コスト考慮点**:
- モデルによってコストが異なる（大きいモデルは高い）
- 処理するデータ量に比例
- 開発時は小さいモデルでテスト推奨

---

## 13. よくある間違いと注意点

### 12.1 関数関連

| 間違い | 正しい理解 |
|--------|-----------|
| Cortex関数はWarehouseで実行される | Cortexはサーバーレスで別途課金 |
| SUMMARIZEにモデル指定が必要 | SUMMARIZEはモデル指定不要 |
| SENTIMENTの結果は0か1 | -1.0から1.0の連続値 |

### 12.2 セキュリティ関連

| 間違い | 正しい理解 |
|--------|-----------|
| Cortexはデータを外部に送信する | データはSnowflake内に留まる |
| 誰でもCortex関数を使える | 通常のRBACで制御される |

### 12.3 コスト関連

| 間違い | 正しい理解 |
|--------|-----------|
| Cortexは無料で使える | クレジット消費による課金 |
| 全モデルのコストは同じ | モデルサイズによってコストが異なる |

---

## 14. 理解度チェック

### Q1. Cortexの特徴
Snowflake Cortexを使う最大のメリットを説明してください。

<details>
<summary>解答</summary>

**データがSnowflake内に留まる**ことです。外部のAIサービスにデータを送信する必要がないため、セキュリティリスクが低減されます。
</details>

### Q2. SENTIMENT関数
SENTIMENT関数の戻り値の範囲と、各範囲の意味を説明してください。

<details>
<summary>解答</summary>

- 戻り値の範囲: **-1.0 から 1.0**
- -1.0に近い: ネガティブ（否定的な感情）
- 0に近い: ニュートラル（中立）
- 1.0に近い: ポジティブ（肯定的な感情）
</details>

### Q3. COMPLETE関数
COMPLETE関数で使用できるLLMモデルを2つ挙げてください。

<details>
<summary>解答</summary>

以下から2つ:
- `claude-opus-4.6`（Anthropic）
- `gpt-5.2`（OpenAI）
- `llama4-maverick`（Meta）
- `llama4-scout`（Meta）
- `snowflake-llama-3.3-70b`（Snowflake）
- `snowflake-arctic`（Snowflake）
- `mistral-large`（Mistral AI）
</details>

### Q4. EMBED_TEXT_768
EMBED_TEXT_768関数は何を返しますか？また、何に使われますか？

<details>
<summary>解答</summary>

- **戻り値**: 768次元のベクトル（数値の配列）
- **用途**: 意味的な類似度検索、レコメンデーション、重複検出など。テキストをベクトルに変換することで、意味的に似たテキストを見つけられます。
</details>

### Q5. 課金
Cortex関数の課金方式を説明してください。

<details>
<summary>解答</summary>

**クレジット消費**に基づく課金です。Warehouseのコンピュートとは別に、Cortex専用のサーバーレスコンピュートで課金されます。使用するモデルや処理データ量によってコストが変わります。
</details>

---

## 15. 試験対策ポイント

- [ ] Snowflake Cortexの概要（LLMへのアクセス、ネイティブ統合）を説明できる
- [ ] データがSnowflake内に留まるというセキュリティ特性を理解している
- [ ] 主要なLLM関数（COMPLETE、SUMMARIZE、TRANSLATE、SENTIMENT、EXTRACT_ANSWER）を知っている
- [ ] 新しいAI Functions（AI_CLASSIFY、AI_TRANSCRIBE等）の存在を把握している
- [ ] 各関数の基本的な構文と用途を理解している
- [ ] COMPLETE関数で利用可能なモデル（Claude、GPT、Llama等）を把握している
- [ ] SENTIMENTのスコア範囲（-1.0〜1.0）を理解している
- [ ] EMBED_TEXT_768がベクトル埋め込みを生成することを知っている
- [ ] Cortex関数がクレジット消費で課金されることを理解している
- [ ] Snowflake Copilotが自然言語からSQL生成する機能であることを知っている
- [ ] マルチモーダル対応（テキスト、画像、音声、動画）を理解している
- [ ] PARSE_DOCUMENT関数の目的（PDFや画像からテキストを抽出する）を理解している
- [ ] PARSE_DOCUMENTのモード（LAYOUT vs OCR）の違いを説明できる
