# Lesson 3: 最初のモデルを作って実行する

> **所要時間**: 25分  
> **形式**: モデルを1つずつ書き、compile → run → 結果確認のサイクルを回す

---

## ゴール

このレッスンを終えると：
- Staging モデルを自分で書ける
- `dbt compile` で生成 SQL を確認できる
- `dbt run` でモデルを Snowflake に作成できる
- `ref()` でモデル同士をつなげられる

---

## Step 1: 最初の staging モデルを書く

> **やること**: `hands-on/dbt/dbt_learn/models/staging/stg_orders.sql` を開き確認する。

```sql
SELECT
    o_orderkey AS order_id,
    o_custkey AS customer_id,
    o_orderstatus AS order_status,
    o_totalprice AS total_price,
    o_orderdate AS order_date,
    o_orderpriority AS order_priority
FROM {{ source('tpch', 'orders') }}
```

### やっていること

1. ソーステーブル `ORDERS` を参照（`source('tpch', 'orders')`）
2. 暗号的なカラム名（`o_orderkey`）を意味のある名前（`order_id`）にリネーム
3. 必要なカラムだけ選択

---

## Step 2: compile で生成 SQL を確認する

> **やること**: ターミナルで実行する。

```bash
dbt compile --select stg_orders --project-dir hands-on/dbt/dbt_learn
```

### 確認ポイント

`target/compiled/dbt_learn/models/staging/stg_orders.sql` に展開後の SQL が出る：

```sql
SELECT
    o_orderkey AS order_id,
    o_custkey AS customer_id,
    o_orderstatus AS order_status,
    o_totalprice AS total_price,
    o_orderdate AS order_date,
    o_orderpriority AS order_priority
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS
```

> **注目**: `{{ source('tpch', 'orders') }}` が `SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS` に展開されている！

---

## Step 3: 1モデルだけ run する

> **やること**: 

```bash
dbt run --select stg_orders --project-dir hands-on/dbt/dbt_learn
```

### 期待する結果

```
1 of 1 START sql view model ANALYTICS.STG_ORDERS
1 of 1 OK created sql view model ANALYTICS.STG_ORDERS

Completed successfully
Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1
```

---

## Step 4: Snowflake で結果を確認する

> **やること**: SQL Worksheet で以下を実行。

```sql
-- ビューが作成されたことを確認
SHOW VIEWS IN SCHEMA DBT_LEARN.ANALYTICS;
```

```sql
-- 中身を確認（カラム名がリネームされている！）
SELECT * FROM DBT_LEARN.ANALYTICS.STG_ORDERS LIMIT 5;
```

```sql
-- 行数を確認
SELECT COUNT(*) AS row_count FROM DBT_LEARN.ANALYTICS.STG_ORDERS;
-- → 1,500,000 行
```

> **チェックポイント**: カラム名が `ORDER_ID`, `CUSTOMER_ID` ... になっていることを確認。  
> ソースの `O_ORDERKEY`, `O_CUSTKEY` ではなくなっている！

---

## Step 5: 残りの staging モデルを作る

同じ要領で残りのモデルが既に用意されている。ファイルを開いて中身を確認しよう：

### models/staging/stg_customers.sql

```sql
SELECT
    c_custkey AS customer_id,
    c_name AS customer_name,
    c_nationkey AS nation_id,
    c_acctbal AS account_balance,
    c_mktsegment AS market_segment
FROM {{ source('tpch', 'customer') }}
```

### models/staging/stg_nations.sql

```sql
SELECT
    n_nationkey AS nation_id,
    n_name AS nation_name,
    n_regionkey AS region_id
FROM {{ source('tpch', 'nation') }}
```

### models/staging/stg_line_items.sql

```sql
SELECT
    l_orderkey AS order_id,
    l_linenumber AS line_number,
    l_partkey AS part_id,
    l_suppkey AS supplier_id,
    l_quantity AS quantity,
    l_extendedprice AS extended_price,
    l_discount AS discount,
    l_tax AS tax,
    l_returnflag AS return_flag,
    l_linestatus AS line_status,
    l_shipdate AS ship_date
FROM {{ source('tpch', 'lineitem') }}
```

---

## Step 6: 全 staging モデルを実行する

> **やること**:

```bash
dbt run --select staging --project-dir hands-on/dbt/dbt_learn
```

### 期待する結果

```
Done. PASS=4 WARN=0 ERROR=0 SKIP=0 TOTAL=4
```

4つのビューが作成される。

---

## Step 7: ref() を使って Mart モデルを作る

> **やること**: `hands-on/dbt/dbt_learn/models/marts/fct_orders.sql` の内容を確認する。

```sql
SELECT
    o.order_id,
    o.customer_id,
    c.customer_name,
    c.market_segment,
    n.nation_name,
    o.order_status,
    o.total_price,
    o.order_date,
    o.order_priority
FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ ref('stg_customers') }} c
    ON o.customer_id = c.customer_id
LEFT JOIN {{ ref('stg_nations') }} n
    ON c.nation_id = n.nation_id
```

### ref() のポイント

- `{{ ref('stg_orders') }}` → `DBT_LEARN.ANALYTICS.STG_ORDERS` に展開
- **依存関係を宣言**: dbt は stg_orders → fct_orders の順で実行する
- ハードコードしないので、スキーマ名が変わっても自動追従(sources.ymlでソースとなるデータベースやスキーマが管理される)

---

## Step 8: compile で ref の展開を確認する

```bash
dbt compile --select fct_orders --project-dir hands-on/dbt/dbt_learn
```

展開結果を確認して、`ref()` が実際のテーブル名に変わっていることを見る。

```sql
SELECT
    o.order_id,
    o.customer_id,
    c.customer_name,
    c.market_segment,
    n.nation_name,
    o.order_status,
    o.total_price,
    o.order_date,
    o.order_priority
FROM DBT_LEARN.ANALYTICS.stg_orders o
LEFT JOIN DBT_LEARN.ANALYTICS.stg_customers c
    ON o.customer_id = c.customer_id
LEFT JOIN DBT_LEARN.ANALYTICS.stg_nations n
    ON c.nation_id = n.nation_id
```
と展開される

---

## Step 9: fct_orders を実行する

```bash
dbt run --select fct_orders --project-dir hands-on/dbt/dbt_learn
```

### 期待する結果

```
1 of 1 START sql table model ANALYTICS.FCT_ORDERS
1 of 1 OK created sql table model ANALYTICS.FCT_ORDERS
```

> **注目**: `view` ではなく `table` と表示される。  
> → `dbt_project.yml` で `marts: +materialized: table` と設定したため。

---

## Step 10: 結果を SQL で確認する

```sql
-- テーブルとして作成されていることを確認
SHOW TABLES IN SCHEMA DBT_LEARN.ANALYTICS;
```

```sql
-- 中身を見る：顧客名・国名が結合されている
SELECT * FROM DBT_LEARN.ANALYTICS.FCT_ORDERS LIMIT 10;
```

```sql
-- 国別の売上ランキングを出してみる
SELECT
    nation_name,
    COUNT(*) AS order_count,
    ROUND(SUM(total_price), 2) AS total_revenue
FROM DBT_LEARN.ANALYTICS.FCT_ORDERS
GROUP BY nation_name
ORDER BY total_revenue DESC
LIMIT 5;
```

> **チェックポイント**: 国名付きで集計できている！  
> staging 層のリネームと marts 層の結合が組み合わさった結果。

---

## Step 11: DAG を体感する — +（プラス）セレクター

`+fct_orders` と書くと、fct_orders **とその上流全て** を実行する：

```bash
dbt run --select +fct_orders --project-dir hands-on/dbt/dbt_learn
```

### 期待する結果

```
Done. PASS=4 WARN=0 ERROR=0 SKIP=0 TOTAL=4
```

stg_orders, stg_customers, stg_nations, fct_orders の4つが依存順で実行される。  
（stg_line_items は fct_orders と無関係なので実行されない）

---

## Step 12: 実験 — わざとエラーを起こす

> **やること**: `stg_orders.sql` の `source` を間違えてみる。

一時的に `FROM {{ source('tpch', 'NONEXISTENT') }}` に変更して：

```bash
dbt run --select stg_orders --project-dir hands-on/dbt/dbt_learn
```

**エラーが出る！** → 元に戻す。

> **学び**: dbt は SQL の実行エラーを明確に報告する。どのモデルで失敗したか一目瞭然。

---

## 確認クイズ

1. `{{ source('tpch', 'orders') }}` は実行時に何に展開される？
2. staging 層のマテリアライゼーションは何？（この設定はどこで行った？）
3. `dbt run --select +fct_orders` の `+` は何を意味する？
4. `ref('stg_orders')` と `source('tpch', 'orders')` の違いは？

<details>
<summary>答えを見る</summary>

1. `SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS`
2. `view`。`dbt_project.yml` の `models.dbt_learn.staging.+materialized: view` で設定
3. そのモデルの**上流（依存先）全て**を含めて実行する
4. `source()` = dbt 管理外のソーステーブル、`ref()` = dbt が管理する別モデルの出力

</details>

---

## このレッスンで作ったもの

- [x] 4つの staging ビュー（stg_orders, stg_customers, stg_nations, stg_line_items）
- [x] 1つの mart テーブル（fct_orders）
- [x] `dbt compile` で Jinja 展開を確認
- [x] `dbt run` でモデルを Snowflake に実体化
- [x] SQL Worksheet で結果を検証

---

## 演習問題

→ [演習 1: stg_regions モデルを作成する](exercises/lesson_03/exercise_01.md)  
→ [演習 2: fct_orders に地域名を追加する](exercises/lesson_03/exercise_02.md)

---

## 次のレッスン

→ [Lesson 4: Marts 層を充実させる](lesson_04_marts_and_materialization.md)
