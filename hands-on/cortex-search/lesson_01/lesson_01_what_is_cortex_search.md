# Lesson 1: Cortex Search を体感する

> **所要時間**: 25分  
> **形式**: SQL を実行しながら Cortex Search の基本を体験する

---

## ゴール

このレッスンを終えると、以下が分かる：
- Cortex Search がどのような検索機能を提供するのか
- LIKE 検索とセマンティック検索の決定的な違い
- Cortex Search Service の作成方法と基本的な検索クエリの書き方

---

## Step 1: 学習環境を準備する

> **やること**: 以下の SQL を Snowsight の SQL Worksheet で実行し、学習用の環境を作成する。

```sql
-- 1-1: 学習用データベース・スキーマを作成
CREATE DATABASE IF NOT EXISTS CORTEX_SEARCH_LEARN;
CREATE SCHEMA IF NOT EXISTS CORTEX_SEARCH_LEARN.DATA;
CREATE SCHEMA IF NOT EXISTS CORTEX_SEARCH_LEARN.SEARCH;
```

> **チェックポイント**: エラーなく実行できたか？

---

## Step 2: サンプルデータを作成する

> **やること**: 製品 FAQ のサンプルデータを作成する。

```sql
-- 2-1: 製品FAQテーブルを作成
CREATE OR REPLACE TABLE CORTEX_SEARCH_LEARN.DATA.PRODUCT_FAQ (
    id INT,
    question TEXT,
    answer TEXT,
    category VARCHAR(50)
);

-- 2-2: サンプルデータを投入
INSERT INTO CORTEX_SEARCH_LEARN.DATA.PRODUCT_FAQ VALUES
(1, '返品はできますか？', '購入後30日以内であれば返品可能です。商品が未使用・未開封の状態に限ります。返品送料はお客様負担となります。', 'returns'),
(2, '配送にどのくらいかかりますか？', '通常配送は3〜5営業日、お急ぎ便は翌日〜2営業日でお届けします。離島・山間部は追加で2〜3日かかる場合があります。', 'shipping'),
(3, '支払い方法は何がありますか？', 'クレジットカード（VISA/Mastercard/JCB/AMEX）、銀行振込、コンビニ払い、代金引換に対応しています。', 'payment'),
(4, '商品の保証期間はどのくらいですか？', '電子機器は購入日から1年間のメーカー保証が付きます。延長保証（有料）で最大3年まで延ばせます。', 'warranty'),
(5, '注文をキャンセルできますか？', '発送前であればマイページからキャンセル可能です。発送後のキャンセルは返品扱いとなります。', 'orders'),
(6, '領収書は発行できますか？', 'マイページの注文履歴から PDF 形式で領収書をダウンロードできます。宛名の変更も可能です。', 'orders'),
(7, 'ポイントの有効期限はいつですか？', '最終購入日から1年間有効です。期限切れ前にメールでお知らせします。', 'loyalty'),
(8, '商品が届かない場合はどうすればよいですか？', '配送予定日を過ぎても届かない場合は、カスタマーサポートまでお問い合わせください。追跡番号で配送状況を確認いたします。', 'shipping'),
(9, 'サイズ交換は可能ですか？', '衣料品・靴のサイズ交換は購入後14日以内、タグ未取り外しの状態であれば無料で承ります。', 'returns'),
(10, '定期購入を解約するには？', 'マイページの「定期購入管理」から次回配送日の5日前までに手続きしてください。解約料は発生しません。', 'subscription');
```

```sql
-- 2-3: データを確認
SELECT * FROM CORTEX_SEARCH_LEARN.DATA.PRODUCT_FAQ;
```

> **チェックポイント**: 10件のデータが表示されたか？

---

## Step 3: まず LIKE 検索の限界を体感する

> **やること**: 従来の文字列検索で「商品を返したい」という意図を検索してみる。

```sql
-- 3-1: LIKE 検索で「返品」を探す
SELECT id, question, answer
FROM CORTEX_SEARCH_LEARN.DATA.PRODUCT_FAQ
WHERE answer LIKE '%返品%';
```

**結果**: `返品` という文字列を含む行だけがヒットする。

```sql
-- 3-2: 「商品を返したい」で LIKE 検索してみる
SELECT id, question, answer
FROM CORTEX_SEARCH_LEARN.DATA.PRODUCT_FAQ
WHERE answer LIKE '%商品を返したい%';
```

**結果**: 0件。「返品」と「商品を返したい」は同じ意味だが、文字列が一致しないため見つからない。

> **問い**: ユーザーが「買ったものを返したい」と検索したらどうなる？  
> → LIKE 検索では対応不可能。これがセマンティック検索が必要な理由。

---

## Step 4: Cortex Search Service を作成する

> **やること**: FAQ データに対してセマンティック検索サービスを作成する。

```sql
-- 4-1: Cortex Search Service を作成
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
```

**パラメータの意味**:

| パラメータ | 説明 |
|-----------|------|
| `ON answer` | 検索対象のテキストカラム |
| `ATTRIBUTES category` | フィルタに使えるカラム |
| `WAREHOUSE` | インデックス構築に使うウェアハウス |
| `TARGET_LAG` | データ更新からインデックス反映までの許容遅延 |
| `AS (SELECT ...)` | 検索対象データを定義するクエリ |

> **注意**: サービス作成には数十秒〜数分かかる場合があります。

---

## Step 5: セマンティック検索を体感する

> **やること**: 先ほど LIKE 検索では見つからなかった意図を、Cortex Search で検索する。

```sql
-- 5-1: 「商品を返したい」で検索
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
```

> **チェックポイント**: 「返品」に関する FAQ がヒットしたか？  
> LIKE 検索では 0件だったのに、意味を理解して「返品」関連の回答が返ってくる！

```sql
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
```

```sql
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
```

> **体感ポイント**:
> - 「届くまで何日かかる」→ 配送に関する FAQ がヒット
> - 「お金の払い方」→ 支払い方法の FAQ がヒット
> - いずれも完全一致ではなく、**意味の近さ** で検索されている

---

## Step 6: キーワードを整理する

| 用語 | 意味 | たとえ話 |
|------|------|---------|
| **Cortex Search Service** | セマンティック検索のマネージドサービス | 「賢い検索エンジン」 |
| **ON カラム** | 検索対象のテキストカラム | 「本の本文」 |
| **ATTRIBUTES** | フィルタや返却に使える追加カラム | 「本のタグ・カテゴリ」 |
| **TARGET_LAG** | データ更新の反映遅延許容値 | 「索引の更新頻度」 |
| **セマンティック検索** | 文字列ではなく意味で検索 | 「辞書ではなく秘書に聞く」 |
| **SEARCH_PREVIEW** | 検索を実行する関数 | 「検索窓にクエリを入力」 |

---

## Step 7: 片付け（任意）

次のレッスンでも使うため、そのまま残しておくことを推奨。
削除したい場合は以下を実行：

```sql
DROP CORTEX SEARCH SERVICE IF EXISTS CORTEX_SEARCH_LEARN.SEARCH.FAQ_SEARCH;
DROP TABLE IF EXISTS CORTEX_SEARCH_LEARN.DATA.PRODUCT_FAQ;
```

---

## 確認クイズ

以下に答えられれば Lesson 1 は完了：

1. Cortex Search は何に基づいて検索する？（文字列一致 / 意味の近さ）
2. `ON` パラメータで指定するのは何？
3. `TARGET_LAG` は何を制御する？
4. LIKE 検索と比べた Cortex Search の最大の利点は？

<details>
<summary>答えを見る</summary>

1. **意味の近さ**（セマンティック検索）
2. 検索対象となるテキストカラム
3. ソースデータの更新がインデックスに反映されるまでの許容遅延時間
4. ユーザーが使う表現がソースデータと完全一致しなくても、意味的に関連する結果を返せる

</details>

---

## 演習問題

→ [演習: 検索クエリの実験](exercise_01.md)

---

## 次のレッスン

→ [Lesson 2: フィルタと属性で精密検索](../lesson_02/lesson_02_filters_and_attributes.md)
