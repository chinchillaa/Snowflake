# Lesson 3: 実践 RAG パイプライン構築

> **所要時間**: 35分  
> **形式**: Cortex Search + COMPLETE() を組み合わせて質問応答システムを構築する

---

## ゴール

このレッスンを終えると、以下が分かる：
- RAG（Retrieval-Augmented Generation）の仕組みと利点
- Cortex Search で関連ドキュメントを取得し、LLM に渡す方法
- プロンプト設計の基本と回答品質の制御

---

## RAG とは

RAG = **R**etrieval-**A**ugmented **G**eneration（検索拡張生成）

```
ユーザーの質問
    ↓
[1] Cortex Search で関連ドキュメントを検索（Retrieval）
    ↓
[2] 検索結果をコンテキストとして LLM に渡す（Augmentation）
    ↓
[3] LLM が回答を生成（Generation）
    ↓
根拠に基づいた回答
```

**利点**:
- LLM が学習していない社内情報にも回答可能
- 回答の根拠（出典）を明示できる
- ハルシネーション（嘘）を減らせる

---

## Step 1: ナレッジベースデータを作成する

```sql
-- 1-1: 社内ナレッジベーステーブル
CREATE OR REPLACE TABLE CORTEX_SEARCH_LEARN.DATA.KNOWLEDGE_BASE (
    doc_id INT,
    title VARCHAR(200),
    content TEXT,
    department VARCHAR(50),
    doc_type VARCHAR(30)
);

-- 1-2: サンプルデータ投入（社内規定・手順書）
INSERT INTO CORTEX_SEARCH_LEARN.DATA.KNOWLEDGE_BASE VALUES
(1, '有給休暇の取得ルール', '年次有給休暇は入社6ヶ月後に10日付与されます。取得する場合は少なくとも3営業日前までに上長に申請してください。半日単位での取得も可能です。未消化分は翌年に限り繰り越せます。年間5日以上の取得が法律で義務付けられています。', '人事', 'policy'),
(2, '経費精算の手順', '経費精算は発生日から1ヶ月以内に申請してください。領収書の原本またはスキャン画像を添付し、経費精算システムから申請します。5万円以上は部長承認が必要です。交通費はICカード履歴でも代替可能です。', '経理', 'procedure'),
(3, 'リモートワーク規定', '週3日までリモートワークが可能です。事前に上長の承認を得てください。コアタイム（10:00-15:00）はオンラインであることが必須です。セキュリティのため、公共Wi-Fiでの業務は禁止です。VPN接続を必ず使用してください。', '人事', 'policy'),
(4, '会議室予約方法', '社内ポータルの「施設予約」から予約してください。予約は最大2週間先まで可能です。30分以上の未使用は自動キャンセルされます。10名以上の会議は大会議室（3F）を使用してください。オンライン会議設備は全室に完備しています。', '総務', 'procedure'),
(5, 'セキュリティインシデント報告', 'セキュリティインシデントを発見した場合は、直ちに情報セキュリティ部門（security@example.com）に報告してください。不審なメールの開封、端末の紛失、不正アクセスの疑いが対象です。報告は24時間以内に行うことが義務付けられています。', 'セキュリティ', 'policy'),
(6, '新入社員オンボーディング', '入社初日は9:00に人事部（2F）に集合してください。初日は環境セットアップ、セキュリティ研修、部署紹介を行います。PCとアカウントは事前に準備されています。メンター制度により、最初の3ヶ月は専任のメンターがサポートします。', '人事', 'procedure'),
(7, '社用端末の管理', '社用PCは退社時にロックし、社外持ち出し時は暗号化を確認してください。紛失した場合は直ちにIT部門に連絡し、リモートワイプを依頼してください。私用ソフトウェアのインストールは禁止です。', 'セキュリティ', 'policy'),
(8, '評価制度について', '人事評価は年2回（4月・10月）実施されます。目標管理（MBO）と360度評価を組み合わせています。期初に上長と目標を設定し、期末に達成度を評価します。評価結果は賞与と昇給に反映されます。', '人事', 'policy'),
(9, '福利厚生一覧', '健康保険、厚生年金、雇用保険に加入しています。その他、社員食堂（昼食補助あり）、フィットネスジム法人契約、資格取得支援（年間10万円まで）、育児・介護休業制度があります。詳細は社内ポータルを確認してください。', '人事', 'information'),
(10, '出張申請の流れ', '出張は2週間前までに出張申請システムから申請してください。国内出張は部長承認、海外出張は役員承認が必要です。宿泊費上限は国内1万円/泊、海外は地域別に設定されています。出張後1週間以内に報告書を提出してください。', '経理', 'procedure'),
(11, 'Slack 利用ガイドライン', '業務連絡は原則 Slack で行います。チャンネル名は「#部署名-用途」の形式で作成してください。機密情報はDMではなく、限定チャンネルで共有してください。リアクションでの既読確認を推奨します。', '総務', 'guideline'),
(12, 'パスワードポリシー', 'パスワードは12文字以上、英大文字・小文字・数字・記号を含めてください。90日ごとに変更が必要です。過去5回分と同じパスワードは使用不可です。多要素認証（MFA）の設定は全社員必須です。', 'セキュリティ', 'policy'),
(13, '請求書の発行方法', '請求書は経理システムから発行してください。月末締め翌月末払いが標準です。振込先は会社指定口座を使用します。インボイス制度対応のため、適格請求書発行事業者番号を必ず記載してください。', '経理', 'procedure'),
(14, '健康診断について', '年1回の定期健康診断は全社員必須です。35歳以上は人間ドックも選択可能（会社負担）。受診期間は毎年4月〜6月です。再検査が必要な場合、勤務時間内の受診が認められます。', '人事', 'information'),
(15, '災害時の対応', '地震・火災発生時は社内放送に従い避難してください。安否確認は専用アプリで報告します。自宅待機判断は災害対策本部から全社メールで通知されます。BCP（事業継続計画）に基づき、重要業務は72時間以内に復旧を目指します。', '総務', 'policy');
```

```sql
-- 1-3: データ確認
SELECT doc_id, title, department, doc_type
FROM CORTEX_SEARCH_LEARN.DATA.KNOWLEDGE_BASE
ORDER BY doc_id;
```

---

## Step 2: ナレッジベース用の検索サービスを作成

```sql
CREATE OR REPLACE CORTEX SEARCH SERVICE CORTEX_SEARCH_LEARN.SEARCH.KB_SEARCH
  ON content
  ATTRIBUTES department, doc_type
  WAREHOUSE = COMPUTE_WH
  TARGET_LAG = '1 hour'
AS (
  SELECT
      doc_id,
      title,
      content,
      department,
      doc_type
  FROM CORTEX_SEARCH_LEARN.DATA.KNOWLEDGE_BASE
);
```

---

## Step 3: 検索だけで質問に答えてみる（RAG なし）

```sql
-- 3-1: 「有給の申請方法」を検索
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
```

> **問題点**: 検索結果は返るが、ユーザーの質問に対する「回答」にはなっていない。  
> ドキュメントの全文がそのまま返るだけで、要点をまとめてくれない。

---

## Step 4: RAG パイプラインを構築する

> **やること**: 検索結果を LLM（COMPLETE 関数）に渡し、自然な回答を生成する。

```sql
-- 4-1: RAG パイプライン（1つの SQL で完結）
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
```

> **チェックポイント**: 「3営業日前まで」という具体的な回答が生成されたか？

---

## Step 5: さまざまな質問で RAG を試す

```sql
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
```

```sql
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
```

---

## Step 6: ドキュメントに無い質問を試す

```sql
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
```

> **チェックポイント**: 「情報が見つかりません」に近い回答が返るか？  
> プロンプトで「ドキュメントにない場合は答えない」と指示しているため、ハルシネーションを抑制できる。

---

## Step 7: RAG パイプライン設計のポイント

| 設計要素 | 推奨事項 |
|---------|---------|
| 検索件数（limit） | 2〜5件。多すぎるとコンテキストが溢れる |
| フィルタ | 質問のカテゴリが明確な場合は積極的に使う |
| プロンプト | 「根拠のない回答はしない」指示を含める |
| モデル選択 | 精度重視なら大きいモデル、速度重視なら小さいモデル |
| コンテキスト長 | モデルの上限を超えないよう、content の長さに注意 |

---

## Step 8: 片付け（任意）

```sql
DROP CORTEX SEARCH SERVICE IF EXISTS CORTEX_SEARCH_LEARN.SEARCH.KB_SEARCH;
DROP CORTEX SEARCH SERVICE IF EXISTS CORTEX_SEARCH_LEARN.SEARCH.TECH_DOCS_SEARCH;
DROP CORTEX SEARCH SERVICE IF EXISTS CORTEX_SEARCH_LEARN.SEARCH.FAQ_SEARCH;
DROP TABLE IF EXISTS CORTEX_SEARCH_LEARN.DATA.KNOWLEDGE_BASE;
DROP TABLE IF EXISTS CORTEX_SEARCH_LEARN.DATA.TECH_DOCS;
DROP TABLE IF EXISTS CORTEX_SEARCH_LEARN.DATA.PRODUCT_FAQ;
-- DROP DATABASE IF EXISTS CORTEX_SEARCH_LEARN;  -- 全削除する場合
```

---

## 確認クイズ

1. RAG の3ステップを順に答えよ
2. COMPLETE 関数の第1引数は何を指定する？
3. 「ドキュメントにない情報には答えない」を実現するにはどうする？
4. 検索結果の `limit` を増やしすぎると何が起こる？

<details>
<summary>答えを見る</summary>

1. Retrieval（検索）→ Augmentation（コンテキスト付与）→ Generation（生成）
2. 使用する LLM モデル名（例: `snowflake-arctic-instruct`）
3. プロンプトに「ドキュメントに記載のない内容には回答しないでください」等の指示を含める
4. LLM に渡すコンテキストが長くなりすぎ、トークン制限超過やコスト増加、回答精度の低下が起こる

</details>

---

## 演習問題

→ [演習: RAG パイプラインの改良](exercise_01.md)

---

## コース完了

おめでとうございます！ Cortex Search ハンズオンコースを完了しました。

### 学んだこと

| レッスン | 学んだスキル |
|---------|-------------|
| 1 | Cortex Search の基本概念、サービス作成、セマンティック検索 |
| 2 | フィルタ（@eq / @and / @or）、ATTRIBUTES、COLUMNS 制御 |
| 3 | RAG パイプライン設計、COMPLETE との連携、プロンプト設計 |

### 次のステップ

- 自社データで Cortex Search Service を作成してみる
- フィルタ条件をアプリケーション側から動的に制御する
- Streamlit in Snowflake で検索 UI を構築する
- Cortex Analyst と組み合わせたハイブリッド検索を試す
