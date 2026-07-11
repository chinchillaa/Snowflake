# Lesson 1: dbt を体感する

> **所要時間**: 20分  
> **形式**: SQL を実行しながら dbt の必要性を体感する

---

## ゴール

このレッスンを終えると、以下が分かる：
- なぜ生 SQL だけではデータ変換の管理が破綻するのか
- dbt が何を解決するツールなのか
- dbt のキーワード（モデル・ref・source・マテリアライゼーション）の意味

---

## Step 1: ソースデータを見てみよう

> **やること**: 以下の SQL を Snowsight の SQL Worksheet で1つずつ実行し、データの中身を確認する。

```sql
-- 1-1: 注文テーブルの中身を見る
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS LIMIT 10;
```

**確認ポイント**: カラム名が `O_ORDERKEY`, `O_CUSTKEY` のように暗号的なことに注目。

```sql
-- 1-2: 顧客テーブル
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER LIMIT 10;
```

```sql
-- 1-3: 注文明細テーブル
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM LIMIT 5;
```

```sql
-- 1-4: データ量を確認する
SELECT 'ORDERS' AS table_name, COUNT(*) AS row_count FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS
UNION ALL
SELECT 'CUSTOMER', COUNT(*) FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER
UNION ALL
SELECT 'LINEITEM', COUNT(*) FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM;
```

> **チェックポイント** :  
> ORDERS は約 150 万行、LINEITEM は約 600 万行あることを確認できたか？

---

## Step 2: 「普通の SQL」で変換してみる

BI ツール用に「注文 + 顧客名 + 国名」を結合したビューを作りたいとする。

```sql
-- 2-1: 学習用データベースを作る（まだ無い場合）
CREATE DATABASE IF NOT EXISTS DBT_LEARN;
CREATE SCHEMA IF NOT EXISTS DBT_LEARN.ANALYTICS;
```

```sql
-- 2-2: 手動で変換ビューを作ってみる
CREATE OR REPLACE VIEW DBT_LEARN.ANALYTICS.V_ORDERS_MANUAL AS
SELECT
    o.O_ORDERKEY AS order_id,
    o.O_CUSTKEY AS customer_id,
    c.C_NAME AS customer_name,
    c.C_MKTSEGMENT AS market_segment,
    n.N_NAME AS nation_name,
    o.O_ORDERSTATUS AS order_status,
    o.O_TOTALPRICE AS total_price,
    o.O_ORDERDATE AS order_date
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS o
LEFT JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER c
    ON o.O_CUSTKEY = c.C_CUSTKEY
LEFT JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION n
    ON c.C_NATIONKEY = n.N_NATIONKEY;
```

```sql
-- 2-3: 結果を確認
SELECT * FROM DBT_LEARN.ANALYTICS.V_ORDERS_MANUAL LIMIT 10;
```

**動いた！** でも、この方法には問題がある。

---

## Step 3: なぜこれではダメなのか — 問題を体感する

### 問題1: 依存関係が見えない

もし `V_ORDERS_MANUAL` をさらに参照する集計ビューを3つ作ったら？  
さらにその下流のビューが5つあったら？  

```
ORDERS ─→ V_ORDERS_MANUAL ─→ AGG_DAILY_REVENUE ─→ ???
                             ─→ AGG_BY_SEGMENT   ─→ ???
                             ─→ TOP_CUSTOMERS    ─→ ???
```

> **問い**: 今 `V_ORDERS_MANUAL` の定義を変えたい。影響範囲は？  
> → 手動では追跡不可能。

### 問題2: テストがない

```sql
-- このビューに NULL の order_id が紛れ込んでいたら？
SELECT COUNT(*) FROM DBT_LEARN.ANALYTICS.V_ORDERS_MANUAL WHERE order_id IS NULL;
```

> 結果が 0 であることを確認。今回はたまたま問題ないが、**定期的に自動チェックする仕組みがない**。

### 問題3: 変更履歴がない

> **問い**: 先月の自分はこのビューの WHERE 句に何を書いていた？  
> → SQL Worksheet では追跡不可能。

---

## Step 4: dbt が解決する世界を見る

dbt を使うと、先ほどの SQL は以下のように管理される：

```
ファイル: models/staging/stg_orders.sql
─────────────────────────────────────
SELECT
    o_orderkey AS order_id,
    o_custkey AS customer_id,
    o_totalprice AS total_price,
    o_orderdate AS order_date
FROM {{ source('tpch', 'orders') }}
```

```
ファイル: models/marts/fct_orders.sql
─────────────────────────────────────
SELECT
    o.order_id,
    c.customer_name,
    n.nation_name,
    o.total_price
FROM {{ ref('stg_orders') }} o
JOIN {{ ref('stg_customers') }} c ON o.customer_id = c.customer_id
JOIN {{ ref('stg_nations') }} n ON c.nation_id = n.nation_id
```

### dbt が自動でやってくれること

| 課題 | dbt の解決策 |
|------|-------------|
| カラム名が暗号的 | staging 層でリネーム |
| 依存関係が不明 | `ref()` で宣言 → DAG 自動生成 |
| テストがない | YAML 1行で `not_null`, `unique` を追加 |
| 変更履歴がない | ファイルベース → Git 管理可能 |
| 実行順序が不明 | DAG に基づき自動決定 |

---

## Step 5: キーワードを整理する

実際にこの後使うことになる用語を整理しよう：

| 用語 | 意味 | たとえ話 |
|------|------|---------|
| **モデル** | 1つの SELECT 文 = 1つの .sql ファイル | レシピ1品 = 1枚のカード |
| **source()** | dbt 管理外のテーブルを参照する関数 | 「スーパーで買う食材」 |
| **ref()** | 別のモデルを参照する関数 | 「前の工程の中間品を使う」 |
| **マテリアライゼーション** | 出力形式（view / table / incremental） | 「作り置き or 都度調理」 |
| **DAG** | 依存関係を表すグラフ | 「工程表」 |
| **Staging 層** | ソースの軽い整形（リネーム等） | 「下ごしらえ」 |
| **Marts 層** | ビジネスロジックの実装 | 「完成した料理」 |

---

## Step 6: 片付け（任意）

手動で作ったビューを削除：

```sql
DROP VIEW IF EXISTS DBT_LEARN.ANALYTICS.V_ORDERS_MANUAL;
```

---

## 確認クイズ

以下に答えられれば Lesson 1 は完了：

1. dbt は ELT の **E / L / T** のどこを担当する？
2. `{{ ref('stg_orders') }}` は何を意味する？
3. staging 層と marts 層の違いは？
4. view と table のマテリアライゼーションの違いは？

<details>
<summary>答えを見る</summary>

1. **T**（Transform）
2. `stg_orders` モデルの出力テーブル/ビューを参照する（依存関係の宣言）
3. staging = ソースの軽い整形（リネーム）、marts = ビジネスロジック（結合・集計）
4. view = 毎回 SELECT を再実行（軽量）、table = 結果を保存（高速クエリ）

</details>

---

## 演習問題

→ [演習: ソースデータの探索](exercises/lesson_01/exercise_01.md)

---

## 次のレッスン

→ [Lesson 2: Snowflake 上で dbt プロジェクトを作る](lesson_02_setup.md)
