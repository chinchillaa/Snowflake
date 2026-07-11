# Lesson 2: フィルタと属性で精密検索

> **所要時間**: 30分  
> **形式**: SQL を実行しながらフィルタ機能と属性指定を学ぶ

---

## ゴール

このレッスンを終えると、以下が分かる：
- FILTER 句でカテゴリ別に検索結果を絞り込む方法
- ATTRIBUTES と COLUMNS の使い分け
- 複数カラムを活用した実用的な検索サービスの設計

---

## Step 1: 技術ドキュメントデータを作成する

> **やること**: カテゴリ・部署・優先度などメタデータが豊富なドキュメントデータを作成する。

```sql
-- 1-1: テーブル作成
CREATE OR REPLACE TABLE CORTEX_SEARCH_LEARN.DATA.TECH_DOCS (
    doc_id INT,
    title VARCHAR(200),
    content TEXT,
    category VARCHAR(50),
    department VARCHAR(50),
    difficulty VARCHAR(20),
    last_updated DATE
);

-- 1-2: サンプルデータ投入
INSERT INTO CORTEX_SEARCH_LEARN.DATA.TECH_DOCS VALUES
(1, 'Snowflake ウェアハウスのサイズ選定', 'ウェアハウスのサイズはワークロードに応じて選択します。小規模な開発クエリにはX-Small、大量データの変換処理にはLarge以上を推奨します。マルチクラスターを有効にすると同時実行性が向上します。', 'infrastructure', 'データエンジニアリング', 'beginner', '2024-11-01'),
(2, 'データパイプラインの監視設計', 'パイプラインの監視にはSNOWPIPE_STREAMINGのメトリクスとTASK_HISTORYビューを活用します。異常検知にはしきい値ベースのアラートとCortex MLによる異常検知を組み合わせることが効果的です。', 'monitoring', 'データエンジニアリング', 'advanced', '2024-12-15'),
(3, 'アクセス制御のベストプラクティス', 'ロールベースアクセス制御（RBAC）を採用し、最小権限の原則に従います。機能ロールとアクセスロールを分離し、ロール階層を設計することで管理性と安全性を両立します。', 'security', 'セキュリティ', 'intermediate', '2024-10-20'),
(4, 'コスト最適化ガイド', 'ウェアハウスの自動サスペンド設定、リソースモニターの活用、不要なマテリアライズドビューの削除が主な最適化手法です。ACCOUNT_USAGEスキーマで利用状況を定期的に確認しましょう。', 'infrastructure', 'FinOps', 'intermediate', '2025-01-10'),
(5, 'Snowpark Python UDF の作成方法', 'Snowpark を使うと Python で UDF を記述できます。pandas DataFrame に似た API でデータ変換を行い、ウェアハウス上で実行されます。外部パッケージのインストールも可能です。', 'development', 'データエンジニアリング', 'intermediate', '2024-09-05'),
(6, 'データ共有（Secure Data Sharing）入門', 'リーダーアカウントを作成せずにデータを共有できます。共有されたデータはコピーされず、プロバイダーのストレージを直接参照するためリアルタイムに最新データにアクセスできます。', 'collaboration', 'データガバナンス', 'beginner', '2024-08-12'),
(7, 'Time Travel とフェイルセーフ', 'Time Travel を使うと過去のデータ状態にアクセスできます。デフォルトは1日ですが、Enterprise Edition では最大90日まで延長可能です。フェイルセーフはTime Travel 期間後の追加7日間の保護です。', 'infrastructure', 'データエンジニアリング', 'beginner', '2024-11-22'),
(8, 'ストリームとタスクによるCDC', 'ストリームはテーブルの変更データ（INSERT/UPDATE/DELETE）をキャプチャします。タスクと組み合わせることで、変更が発生した時だけ下流の処理を実行する効率的なパイプラインを構築できます。', 'development', 'データエンジニアリング', 'advanced', '2025-01-05'),
(9, 'マスキングポリシーの設定', '動的データマスキングにより、ロールに応じてカラムの表示内容を制御できます。PII（個人情報）カラムに適用し、権限のないユーザーにはマスク済みデータを返します。', 'security', 'セキュリティ', 'intermediate', '2024-12-01'),
(10, 'Cortex LLM 関数の活用', 'COMPLETE関数でテキスト生成、SUMMARIZE関数で要約、SENTIMENT関数で感情分析が可能です。モデルはSnowflake側で管理されるため、APIキー不要で利用開始できます。', 'ai', 'データサイエンス', 'beginner', '2025-02-01'),
(11, '動的テーブル（Dynamic Tables）入門', '動的テーブルはSQLクエリの結果を自動的に最新状態に保つオブジェクトです。TARGET_LAGで更新頻度を制御し、上流テーブルの変更を自動で反映します。ストリーム+タスクの代替として使えます。', 'development', 'データエンジニアリング', 'beginner', '2025-01-20'),
(12, 'ネットワークポリシーによるIP制限', 'ネットワークポリシーを使うと、許可するIPアドレス範囲を制限できます。アカウントレベルまたはユーザーレベルで設定可能です。VPN経由のアクセスのみ許可する構成が一般的です。', 'security', 'セキュリティ', 'intermediate', '2024-10-30'),
(13, 'Iceberg テーブルの利用', 'Apache Iceberg 形式のテーブルをSnowflakeで直接読み書きできます。外部カタログ（AWS Glue等）との連携により、マルチエンジン環境でのデータ共有が容易になります。', 'development', 'データエンジニアリング', 'advanced', '2025-02-10'),
(14, 'ウェアハウス自動スケーリング', 'マルチクラスターウェアハウスを使うと、同時接続数に応じて自動的にクラスターが追加されます。Economyモードはコスト重視、Standardモードはパフォーマンス重視です。', 'infrastructure', 'FinOps', 'intermediate', '2024-11-15'),
(15, 'Snowflake Notebooks の使い方', 'Snowsight 上で Python/SQL を組み合わせたノートブックを実行できます。データ探索、可視化、ML モデルの実験に最適です。Git 連携でバージョン管理も可能です。', 'development', 'データサイエンス', 'beginner', '2025-01-25'),
(16, 'データ品質モニタリング（DMF）', 'Data Metric Functions を使って、テーブルのデータ品質を定期的に測定できます。NULL率、一意性、範囲チェックなどの組み込み関数のほか、カスタム関数も作成可能です。', 'monitoring', 'データガバナンス', 'intermediate', '2025-02-05'),
(17, 'Cortex Search によるセマンティック検索', 'テキストデータに対して意味ベースの検索を提供するマネージドサービスです。インデックス構築は自動で行われ、TARGET_LAGで更新頻度を指定します。RAGパイプラインの検索部分に最適です。', 'ai', 'データサイエンス', 'intermediate', '2025-02-15'),
(18, 'タグベースのガバナンス', 'オブジェクトタグを使って、テーブルやカラムにメタデータを付与できます。タグに基づいてマスキングポリシーを自動適用するタグベースマスキングにより、大規模なガバナンスを効率化します。', 'security', 'データガバナンス', 'advanced', '2024-12-20'),
(19, 'Streamlit in Snowflake', 'Snowflake 内で Streamlit アプリを直接デプロイ・実行できます。データ移動なしでダッシュボードやインタラクティブアプリを構築でき、RBACによるアクセス制御も適用されます。', 'development', 'データサイエンス', 'beginner', '2025-01-15'),
(20, 'クローンとゼロコピー', 'テーブル、スキーマ、データベースのクローンはメタデータのみコピーするため瞬時に完了します。開発環境の作成やテスト用データの準備に活用でき、追加ストレージコストは変更分のみです。', 'infrastructure', 'データエンジニアリング', 'beginner', '2024-09-30');
```

```sql
-- 1-3: データ確認
SELECT doc_id, title, category, department, difficulty
FROM CORTEX_SEARCH_LEARN.DATA.TECH_DOCS
ORDER BY doc_id;
```

> **チェックポイント**: 20件のドキュメントが表示されたか？

---

## Step 2: 複数属性を持つ検索サービスを作成する

```sql
-- 2-1: 属性を複数指定した検索サービスを作成
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
```

> **ポイント**: `ATTRIBUTES` に複数カラムを指定すると、それぞれでフィルタリングが可能になる。

---

## Step 3: フィルタなし検索（ベースライン）

```sql
-- 3-1: 「セキュリティの設定方法」で検索（フィルタなし）
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
```

> **観察**: セキュリティ以外のカテゴリのドキュメントも含まれる可能性がある。

---

## Step 4: FILTER でカテゴリを絞り込む

```sql
-- 4-1: security カテゴリのみに絞り込み
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
```

> **チェックポイント**: category が全て "security" の結果のみ返ってくるか？

```sql
-- 4-2: 部署でフィルタ（データサイエンスチームのドキュメントのみ）
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
```

---

## Step 5: 複合フィルタを使う

```sql
-- 5-1: AND 条件 — 初心者向け かつ 開発カテゴリ
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
```

```sql
-- 5-2: OR 条件 — security または monitoring カテゴリ
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
```

---

## Step 6: COLUMNS で返却カラムを制御する

```sql
-- 6-1: 最小限の情報のみ返す
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

-- 6-2: 全カラムを返す
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'CORTEX_SEARCH_LEARN.SEARCH.TECH_DOCS_SEARCH',
    '{
      "query": "コスト削減",
      "columns": ["doc_id", "title", "content", "category", "department", "difficulty", "last_updated"],
      "limit": 3
    }'
  )
):results AS results;
```

> **ポイント**: `columns` で返すカラムを指定することで、不要なデータ転送を減らせる。RAG パイプラインでは `content` のみ必要な場合が多い。

---

## Step 7: フィルタ構文まとめ

| 構文 | 意味 | 例 |
|------|------|-----|
| `{"@eq": {"col": "val"}}` | 等値一致 | category = "security" |
| `{"@and": [...]}` | AND 結合 | 複数条件を全て満たす |
| `{"@or": [...]}` | OR 結合 | いずれかの条件を満たす |

---

## 確認クイズ

1. `ATTRIBUTES` で指定したカラムは何に使える？
2. `filter` と `columns` の違いは？
3. AND と OR フィルタを組み合わせるにはどう書く？
4. `columns` に指定しなかったカラムはどうなる？

<details>
<summary>答えを見る</summary>

1. 検索結果のフィルタリング（絞り込み）に使える
2. `filter` は検索対象を絞り込む（WHERE 句相当）、`columns` は返却するカラムを指定する（SELECT 句相当）
3. `@and` の配列内に `@or` をネストする（またはその逆）
4. 結果に含まれない（指定したカラムのみ返却される）

</details>

---

## 演習問題

→ [演習: フィルタ検索の実践](exercise_01.md)

---

## 次のレッスン

→ [Lesson 3: 実践 RAG パイプライン構築](../lesson_03/lesson_03_rag_pipeline.md)
