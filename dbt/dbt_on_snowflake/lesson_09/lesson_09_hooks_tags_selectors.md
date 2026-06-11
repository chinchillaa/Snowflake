# Lesson 9: hooks・tags・セレクタで運用を効率化する

> **所要時間**: 30分  
> **形式**: hooks で自動処理を仕込む → tags でモデルを分類 → セレクタで柔軟に実行対象を選ぶ

---

## ゴール

このレッスンを終えると：
- pre-hook / post-hook でモデル実行前後に任意 SQL を自動実行できる
- tags を使ってモデルをグルーピングし、選択実行できる
- セレクタ構文（`--select`, `--exclude`, `+`, `@`）を使いこなせる
- `on-run-start` / `on-run-end` でプロジェクト全体の前後処理ができる

---

## 背景: 本番運用で直面する課題

Lesson 7 でデプロイとスケジュール実行ができるようになった。  
しかし本番運用では以下のような要望が出てくる：

- 「テーブル作成後に自動で GRANT したい」
- 「夜間バッチでは全モデル、日中は marts だけ実行したい」
- 「あるモデルとその下流だけ再実行したい」

→ hooks・tags・セレクタがこれらを解決する。

---

## Step 1: post-hook で自動 GRANT を設定する

> **やること**: `dbt/dbt_learn/models/marts/dim_customers.sql` の config に post-hook を追加する。

```sql
{{
    config(
        materialized='table',
        post_hook="GRANT SELECT ON {{ this }} TO ROLE PUBLIC"
    )
}}

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

### 解説

- `post_hook` はモデルの CREATE/INSERT が完了した **直後** に実行される
- `{{ this }}` はモデル自身のフルパス（`DBT_LEARN.ANALYTICS.DIM_CUSTOMERS`）に展開される
- 実務では GRANT、COMMENT、ALTER TABLE などに使う

---

## Step 2: compile で hook の展開を確認する

```bash
dbt compile --select dim_customers --project-dir dbt/dbt_learn
```

> **確認ポイント**: compiled SQL の末尾に `GRANT SELECT ON ...` が含まれていること。

---

## Step 3: pre-hook でログテーブルに記録する

> **やること**: ログテーブルを作成し、pre-hook で実行開始を記録する仕組みを作る。

```sql
-- SQL Worksheet で実行
CREATE TABLE IF NOT EXISTS DBT_LEARN.ANALYTICS.DBT_RUN_LOG (
    model_name   VARCHAR,
    started_at   TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    run_type     VARCHAR DEFAULT 'model_run'
);
```

> **やること**: `dbt/dbt_learn/models/marts/agg_daily_orders.sql` に pre-hook を追加する。

```sql
{{
    config(
        materialized='table',
        pre_hook="INSERT INTO DBT_LEARN.ANALYTICS.DBT_RUN_LOG (model_name) VALUES ('agg_daily_orders')"
    )
}}

SELECT
    order_date,
    order_status,
    COUNT(*) AS order_count,
    SUM(total_price) AS daily_revenue
FROM {{ ref('stg_orders') }}
GROUP BY order_date, order_status
```

```bash
dbt run --select agg_daily_orders --project-dir dbt/dbt_learn
```

```sql
-- ログが記録されたか確認
SELECT * FROM DBT_LEARN.ANALYTICS.DBT_RUN_LOG ORDER BY started_at DESC LIMIT 5;
```

---

## Step 4: on-run-start / on-run-end をプロジェクトに設定する

> **やること**: `dbt/dbt_learn/dbt_project.yml` に以下を追加する。

```yaml
on-run-start:
  - "INSERT INTO DBT_LEARN.ANALYTICS.DBT_RUN_LOG (model_name, run_type) VALUES ('__PROJECT_START__', 'project_run')"

on-run-end:
  - "INSERT INTO DBT_LEARN.ANALYTICS.DBT_RUN_LOG (model_name, run_type) VALUES ('__PROJECT_END__', 'project_run')"
```

```bash
dbt run --select stg_orders --project-dir dbt/dbt_learn
```

```sql
-- プロジェクト開始/終了のログを確認
SELECT * FROM DBT_LEARN.ANALYTICS.DBT_RUN_LOG
WHERE run_type = 'project_run'
ORDER BY started_at DESC LIMIT 5;
```

> **チェックポイント**: `__PROJECT_START__` と `__PROJECT_END__` が記録されていること。

---

## Step 5: tags でモデルを分類する

> **やること**: 各モデルに tags を付与する。

`dbt_project.yml` の models セクションを以下のように変更：

```yaml
models:
  dbt_learn:
    staging:
      +materialized: view
      +tags: ["staging", "daily"]
    marts:
      +materialized: table
      +tags: ["marts", "daily"]
```

さらに、個別モデルにもタグを付与できる。  
`dbt/dbt_learn/models/marts/agg_daily_orders.sql` の config：

```sql
{{
    config(
        materialized='table',
        tags=['reporting', 'hourly'],
        pre_hook="INSERT INTO DBT_LEARN.ANALYTICS.DBT_RUN_LOG (model_name) VALUES ('agg_daily_orders')"
    )
}}
```

---

## Step 6: tags を使ってセレクティブに実行する

```bash
# "daily" タグが付いたモデルだけ実行
dbt run --select tag:daily --project-dir dbt/dbt_learn

# "reporting" タグのモデルだけテスト
dbt test --select tag:reporting --project-dir dbt/dbt_learn

# "staging" タグを除外して実行
dbt run --exclude tag:staging --project-dir dbt/dbt_learn
```

> **確認ポイント**: 各コマンドの出力で、対象モデルが絞られていることを確認。

---

## Step 7: セレクタ構文をマスターする

dbt のセレクタ構文は強力。以下を実際に試そう：

### 7-1: 特定モデルとその下流（`+` 演算子）

```bash
# stg_orders とその下流（fct_orders, agg_daily_orders 等）を全て実行
dbt run --select stg_orders+ --project-dir dbt/dbt_learn
```

### 7-2: 特定モデルとその上流

```bash
# fct_orders とその上流（stg_orders, stg_customers 等）を全て実行
dbt run --select +fct_orders --project-dir dbt/dbt_learn
```

### 7-3: 上流も下流も含める

```bash
# stg_customers の上流と下流を全て実行
dbt run --select +stg_customers+ --project-dir dbt/dbt_learn
```

### 7-4: パス指定

```bash
# marts ディレクトリのモデルだけ実行
dbt run --select models/marts/ --project-dir dbt/dbt_learn
```

### 7-5: 複数条件の組み合わせ

```bash
# marts かつ daily タグ
dbt run --select tag:daily,path:models/marts --project-dir dbt/dbt_learn
```

### 7-6: list で対象モデルを事前確認

```bash
# 実行せずに対象モデルを確認（dry run 的に使う）
dbt list --select stg_orders+ --project-dir dbt/dbt_learn
```

---

## Step 8: セレクタ構文リファレンス

| 構文 | 意味 | 例 |
|------|------|-----|
| `model_name` | 特定モデル | `stg_orders` |
| `model_name+` | モデル + 下流全て | `stg_orders+` |
| `+model_name` | 上流全て + モデル | `+fct_orders` |
| `+model_name+` | 上流 + モデル + 下流 | `+stg_customers+` |
| `tag:xxx` | タグで絞り込み | `tag:daily` |
| `path:xxx` | ディレクトリで絞り込み | `path:models/marts` |
| `source:xxx` | ソース参照で絞り込み | `source:tpch` |
| `--exclude` | 除外 | `--exclude tag:staging` |

---

## Step 9: 実験 — 影響範囲を可視化する

`stg_orders` を変更したとき、何が影響を受けるかを確認：

```bash
# stg_orders の下流モデルを一覧表示
dbt list --select stg_orders+ --resource-type model --project-dir dbt/dbt_learn
```

> **チェックポイント**: `fct_orders`, `agg_daily_orders`, `dim_customers` など、  
> stg_orders に依存する全モデルが表示されること。

これは本番で「このモデルを変更したら何が壊れる？」を事前に調べる際に非常に有用。

---

## Step 10: on-run-end で一括 GRANT（実践パターン）

個別の post-hook の代わりに、プロジェクト全体の終了後に一括 GRANT するパターン：

`dbt_project.yml`:

```yaml
on-run-end:
  - "GRANT SELECT ON ALL TABLES IN SCHEMA DBT_LEARN.ANALYTICS TO ROLE PUBLIC"
  - "GRANT SELECT ON ALL VIEWS IN SCHEMA DBT_LEARN.ANALYTICS TO ROLE PUBLIC"
  - "INSERT INTO DBT_LEARN.ANALYTICS.DBT_RUN_LOG (model_name, run_type) VALUES ('__PROJECT_END__', 'project_run')"
```

```bash
dbt run --project-dir dbt/dbt_learn
```

```sql
-- GRANT が適用されたか確認
SHOW GRANTS ON SCHEMA DBT_LEARN.ANALYTICS;
```

---

## まとめ

| 学んだこと | キーワード |
|-----------|-----------|
| モデル実行前後の自動処理 | `pre_hook`, `post_hook`, `{{ this }}` |
| プロジェクト全体の前後処理 | `on-run-start`, `on-run-end` |
| モデルの分類 | `tags` |
| 柔軟な実行対象指定 | `--select`, `--exclude`, `+`, `tag:`, `path:` |
| 影響範囲の事前確認 | `dbt list --select model+` |

---

## 確認クイズ

1. `post_hook` と `on-run-end` の違いは？
2. `dbt run --select +fct_orders` は何を実行する？
3. `dbt list` コマンドの用途は？
4. `{{ this }}` は何に展開される？
5. tags をモデル個別に付与する方法と、ディレクトリ単位で付与する方法をそれぞれ説明せよ。

<details>
<summary>答えを見る</summary>

1. `post_hook` = 各モデルの CREATE/INSERT 直後に実行。`on-run-end` = 全モデル実行完了後に1回だけ実行
2. `fct_orders` とその **上流** 全て（stg_orders, stg_customers, stg_nations）を実行する
3. 実行対象となるモデルの一覧を表示する（実際には実行しない＝dry run）
4. モデル自身の完全修飾名（例: `DBT_LEARN.ANALYTICS.DIM_CUSTOMERS`）
5. 個別: `config(tags=['xxx'])` をモデルファイルに記述。ディレクトリ単位: `dbt_project.yml` の models セクションで `+tags: ["xxx"]`

</details>

---

## 演習問題

→ [演習 1: カスタムログマクロを作成する](exercise_01.md)  
→ [演習 2: セレクタを駆使してバッチ戦略を設計する](exercise_02.md)

---

## 次のレッスン

→ [Lesson 10: Dynamic Tables と dbt の連携パターン](../lesson_10/lesson_10_dynamic_tables.md)
