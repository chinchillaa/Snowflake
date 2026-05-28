# Lesson 4: Marts 層を充実させる

> **所要時間**: 30分  
> **形式**: 複数の Mart モデルを作成し、マテリアライゼーションの違いを実験で確認する

---

## ゴール

このレッスンを終えると：
- fct_ / dim_ / agg_ の設計パターンが使える
- view と table の動作の違いを体感できる
- incremental モデルを書ける
- config() ブロックでモデル単位の設定ができる

---

## Step 1: dim_customers を作る

> **やること**: `dbt/dbt_learn/models/marts/dim_customers.sql` の内容を確認する。

```sql
SELECT
    c.customer_id,
    c.customer_name,
    c.market_segment,
    c.account_balance,
    n.nation_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_price) AS lifetime_value,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS last_order_date
FROM {{ ref('stg_customers') }} c
LEFT JOIN {{ ref('stg_nations') }} n
    ON c.nation_id = n.nation_id
LEFT JOIN {{ ref('stg_orders') }} o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.market_segment,
    c.account_balance,
    n.nation_name
```

### 設計のポイント

- `dim_` = ディメンション（属性 + 集計メトリクス）
- 顧客の属性に加え、注文回数・生涯売上・初回/最終注文日を事前計算
- **BI ツールがこのテーブルを直接参照できる状態にする**のが目的

---

## Step 2: 実行して中身を確認

```bash
dbt run --select dim_customers --project-dir dbt/dbt_learn
```

```sql
-- 上位顧客を確認
SELECT customer_name, nation_name, total_orders, lifetime_value
FROM DBT_LEARN.ANALYTICS.DIM_CUSTOMERS
ORDER BY lifetime_value DESC
LIMIT 10;
```

> **チェックポイント**: `lifetime_value` が計算済みで格納されている。  
> BI ツールは GROUP BY なしでこの値を使える。

---

## Step 3: agg_daily_orders を作る

> **やること**: `dbt/dbt_learn/models/marts/agg_daily_orders.sql` を確認する。

```sql
SELECT
    o.order_date,
    n.nation_name,
    c.market_segment,
    COUNT(o.order_id) AS order_count,
    SUM(o.total_price) AS daily_revenue,
    AVG(o.total_price) AS avg_order_value
FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ ref('stg_customers') }} c
    ON o.customer_id = c.customer_id
LEFT JOIN {{ ref('stg_nations') }} n
    ON c.nation_id = n.nation_id
GROUP BY
    o.order_date,
    n.nation_name,
    c.market_segment
```

```bash
dbt run --select agg_daily_orders --project-dir dbt/dbt_learn
```

```sql
-- 日次トレンドを確認
SELECT order_date, SUM(daily_revenue) AS total_revenue
FROM DBT_LEARN.ANALYTICS.AGG_DAILY_ORDERS
WHERE order_date BETWEEN '1997-01-01' AND '1997-01-31'
GROUP BY order_date
ORDER BY order_date;
```

---

## Step 4: 【実験】view vs table の違いを体感する

> **やること**: agg_daily_orders を一時的に `view` に変えて、パフォーマンスの違いを計測する。

### 実験 A: 現在の状態（table）でクエリ

```sql
-- 実行時間を確認（Query Profile で確認可能）
SELECT market_segment, SUM(daily_revenue) AS total
FROM DBT_LEARN.ANALYTICS.AGG_DAILY_ORDERS
GROUP BY market_segment;
```

### 実験 B: view に変更して実行

`agg_daily_orders.sql` の先頭に以下を追加：

```sql
{{ config(materialized='view') }}
```

```bash
dbt run --select agg_daily_orders --project-dir dbt/dbt_learn
```

同じクエリを実行：

```sql
SELECT market_segment, SUM(daily_revenue) AS total
FROM DBT_LEARN.ANALYTICS.AGG_DAILY_ORDERS
GROUP BY market_segment;
```

### 実験結果を比較

| 項目 | table | view |
|------|-------|------|
| dbt run の時間 | 長い（データ書き込み） | 短い（定義のみ） |
| クエリ実行時間 | **短い**（事前計算済み） | 長い（毎回再計算） |
| ストレージ | 使う | 使わない |

> **学び**: データ量が大きく頻繁にクエリされる marts は `table`、軽量なものは `view` が適切。

### 元に戻す

`agg_daily_orders.sql` から `{{ config(materialized='view') }}` を削除し：

```bash
dbt run --select agg_daily_orders --project-dir dbt/dbt_learn
```

---

## Step 5: incremental モデルを理解する

> **やること**: `dbt/dbt_learn/models/marts/fct_line_items.sql` を確認する。

```sql
{{
    config(
        materialized='incremental',
        unique_key=['order_id', 'line_number']
    )
}}

SELECT
    li.order_id,
    li.line_number,
    li.part_id,
    li.supplier_id,
    li.quantity,
    li.extended_price,
    li.discount,
    li.tax,
    li.extended_price * (1 - li.discount) * (1 + li.tax) AS net_price,
    li.return_flag,
    li.line_status,
    li.ship_date
FROM {{ ref('stg_line_items') }} li

{% if is_incremental() %}
WHERE li.ship_date > (SELECT MAX(ship_date) FROM {{ this }})
{% endif %}
```

### 動作の仕組み

```
┌─ 1回目の実行 ─────────────────────────────────┐
│ is_incremental() = FALSE                       │
│ → WHERE 句なし → 全データを CREATE TABLE        │
└───────────────────────────────────────────────┘

┌─ 2回目以降の実行 ─────────────────────────────┐
│ is_incremental() = TRUE                        │
│ → WHERE 句あり → MAX(ship_date) 以降のみ MERGE │
└───────────────────────────────────────────────┘
```

---

## Step 6: incremental モデルを実行する

### 1回目の実行（フルロード）

```bash
dbt run --select fct_line_items --project-dir dbt/dbt_learn
```

```sql
-- 行数を確認
SELECT COUNT(*) FROM DBT_LEARN.ANALYTICS.FCT_LINE_ITEMS;
-- → 約 6,001,215 行

-- MAX(ship_date) を確認
SELECT MAX(ship_date) FROM DBT_LEARN.ANALYTICS.FCT_LINE_ITEMS;
```

### 2回目の実行（差分）

```bash
dbt run --select fct_line_items --project-dir dbt/dbt_learn
```

> **注目**: 2回目は **0行が INSERT** される（新しいデータがないため）。  
> 実行時間が1回目より短いことを確認。

---

## Step 7: --full-refresh を体験する

incremental モデルのロジック（SELECT 句）を変更した場合、既存データは古いロジックのまま。
作り直すには：

```bash
dbt run --select fct_line_items --full-refresh --project-dir dbt/dbt_learn
```

> **ルール**: incremental モデルのカラムや計算ロジックを変えたら `--full-refresh` が必須。

---

## Step 8: 全モデルを一括実行する

```bash
dbt run --project-dir dbt/dbt_learn
```

### 期待する結果

```
Done. PASS=8 WARN=0 ERROR=0 SKIP=0 TOTAL=8
```

staging (4 views) + marts (4 tables) = 8 モデル

---

## Step 9: Snowflake で全体を確認

```sql
-- 作成されたオブジェクト一覧
SELECT table_name, table_type
FROM DBT_LEARN.INFORMATION_SCHEMA.TABLES
WHERE table_schema = 'ANALYTICS'
ORDER BY table_type, table_name;
```

期待する結果：

| TABLE_NAME | TABLE_TYPE |
|-----------|-----------|
| FCT_ORDERS | BASE TABLE |
| FCT_LINE_ITEMS | BASE TABLE |
| DIM_CUSTOMERS | BASE TABLE |
| AGG_DAILY_ORDERS | BASE TABLE |
| STG_ORDERS | VIEW |
| STG_CUSTOMERS | VIEW |
| STG_NATIONS | VIEW |
| STG_LINE_ITEMS | VIEW |

---

## Step 10: マテリアライゼーション選択の判断基準

```
質問: このモデルのデータ量は大きいか？
│
├── NO → 頻繁にクエリされる？
│         ├── YES → table
│         └── NO  → view
│
└── YES → データは時系列で追記型か？
           ├── YES → incremental
           └── NO  → table（定期 full-refresh）
```

---

## 確認クイズ

1. `dim_` と `fct_` と `agg_` の命名規則の違いは？
2. incremental モデルで `is_incremental()` が FALSE になるのはどんなとき？
3. incremental モデルの SELECT 句を変更した後、何をすべき？
4. `config(materialized='view')` をモデルの SQL に書くと、dbt_project.yml のデフォルトより優先されるか？

<details>
<summary>答えを見る</summary>

1. `dim_` = ディメンション（属性）、`fct_` = ファクト（イベント/トランザクション）、`agg_` = 集計サマリー
2. 初回実行時（テーブルがまだ存在しない）、または `--full-refresh` を指定した時
3. `dbt run --select モデル名 --full-refresh` を実行する
4. はい。モデル内の `config()` が最も優先度が高い

</details>

---

## このレッスンで作ったもの

- [x] dim_customers（顧客ディメンション）
- [x] agg_daily_orders（日次集計）
- [x] fct_line_items（incremental モデル）
- [x] view vs table のパフォーマンス差を体感
- [x] incremental の初回/2回目の挙動差を確認

---

## 演習問題

→ [演習 1: マテリアライゼーションの切り替え実験](exercises/lesson_04/exercise_01.md)  
→ [演習 2: incremental モデルのロジック変更](exercises/lesson_04/exercise_02.md)

---

## 次のレッスン

→ [Lesson 5: テストでデータ品質を守る](lesson_05_tests_and_docs.md)
