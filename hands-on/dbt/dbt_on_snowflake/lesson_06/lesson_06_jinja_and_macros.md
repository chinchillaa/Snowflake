# Lesson 6: Jinja テンプレートとマクロ

> **所要時間**: 30分  
> **形式**: Jinja 構文を1つずつ書き、compile で展開結果を確認する

---

## ゴール

このレッスンを終えると：
- `{{ }}`, `{% %}`, `{# #}` の違いが使える
- if / for の制御構文が書ける
- マクロを自分で定義して使える
- `dbt compile` で Jinja → SQL の変換を確認できる

---

## Step 1: Jinja の3つの記法

| 記法 | 用途 | 例 |
|------|------|-----|
| `{{ ... }}` | 値を出力する | `{{ ref('stg_orders') }}` |
| `{% ... %}` | 制御構文（if, for）| `{% if is_incremental() %}` |
| `{# ... #}` | コメント（出力されない） | `{# TODO: 後で修正 #}` |

---

## Step 2: 【実験】変数 var() を使う

> **やること**: 新しいモデルを作って変数を試す。

`hands-on/dbt/dbt_learn/models/marts/recent_orders.sql` を新規作成：

```sql
SELECT
    order_id,
    customer_id,
    total_price,
    order_date
FROM {{ ref('stg_orders') }}
WHERE order_date >= '{{ var("start_date", "1998-01-01") }}'
```

### compile で展開を確認

```bash
dbt compile --select recent_orders --project-dir hands-on/dbt/dbt_learn
```

展開結果（target/compiled/ で確認）：

```sql
SELECT
    order_id,
    customer_id,
    total_price,
    order_date
FROM DBT_LEARN.ANALYTICS.STG_ORDERS
WHERE order_date >= '1998-01-01'
```

### 変数をコマンドラインで上書き

```bash
dbt compile --select recent_orders --vars '{"start_date": "1995-06-01"}' --project-dir hands-on/dbt/dbt_learn
```

展開結果が `'1995-06-01'` に変わることを確認！

---

## Step 3: 【実験】if 文で環境切り替え

> **やること**: `recent_orders.sql` を以下に書き換える。

```sql
SELECT
    order_id,
    customer_id,
    total_price,
    order_date
FROM {{ ref('stg_orders') }}
WHERE order_date >= '{{ var("start_date", "1998-01-01") }}'

{% if target.name == 'dev' %}
LIMIT 10000
{% endif %}
```

```bash
dbt compile --select recent_orders --project-dir hands-on/dbt/dbt_learn
```

> `target.name` は `profiles.yml` の `target: dev` に対応。  
> dev 環境では `LIMIT 10000` が付き、prod では付かない。

### 実行して確認

```bash
dbt run --select recent_orders --project-dir hands-on/dbt/dbt_learn
```

```sql
SELECT COUNT(*) FROM DBT_LEARN.ANALYTICS.RECENT_ORDERS;
-- → 10000 行（dev 環境なので LIMIT が効いている）
```

---

## Step 4: 【実験】for ループで繰り返し SQL を生成

> **やること**: 新規ファイル `hands-on/dbt/dbt_learn/models/marts/order_status_pivot.sql` を作成。

```sql
{% set statuses = ['F', 'O', 'P'] %}

SELECT
    customer_id,
    COUNT(*) AS total_orders,
    {% for status in statuses %}
    COUNT(CASE WHEN order_status = '{{ status }}' THEN 1 END) AS status_{{ status }}_count
    {% if not loop.last %},{% endif %}
    {% endfor %}
FROM {{ ref('stg_orders') }}
GROUP BY customer_id
```

### compile で展開を確認

```bash
dbt compile --select order_status_pivot --project-dir hands-on/dbt/dbt_learn
```

展開後の SQL：

```sql
SELECT
    customer_id,
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN order_status = 'F' THEN 1 END) AS status_F_count,
    COUNT(CASE WHEN order_status = 'O' THEN 1 END) AS status_O_count,
    COUNT(CASE WHEN order_status = 'P' THEN 1 END) AS status_P_count
FROM DBT_LEARN.ANALYTICS.STG_ORDERS
GROUP BY customer_id
```

> **注目**: `loop.last` で最後のカンマを除去している。これは Jinja でのよくあるパターン。

```bash
dbt run --select order_status_pivot --project-dir hands-on/dbt/dbt_learn
```

```sql
SELECT * FROM DBT_LEARN.ANALYTICS.ORDER_STATUS_PIVOT LIMIT 5;
```

---

## Step 5: マクロを定義する

マクロ = 再利用可能な Jinja 関数。`macros/` に置く。

> **やること**: `hands-on/dbt/dbt_learn/macros/limit_in_dev.sql` を確認する。

```sql
{% macro limit_in_dev(row_count=1000) %}
    {% if target.name == 'dev' %}
    LIMIT {{ row_count }}
    {% endif %}
{% endmacro %}
```

### マクロを使ってみる

`recent_orders.sql` を書き換え：

```sql
SELECT
    order_id,
    customer_id,
    total_price,
    order_date
FROM {{ ref('stg_orders') }}
WHERE order_date >= '{{ var("start_date", "1998-01-01") }}'
ORDER BY order_date DESC
{{ limit_in_dev(5000) }}
```

```bash
dbt compile --select recent_orders --project-dir hands-on/dbt/dbt_learn
```

> `LIMIT 5000` が展開されることを確認。

---

## Step 6: 実用マクロを自分で書く

> **やること**: `hands-on/dbt/dbt_learn/macros/clean_string.sql` を新規作成する。

```sql
{% macro clean_string(column_name) %}
    UPPER(TRIM({{ column_name }}))
{% endmacro %}
```

### 使ってみる — stg_customers.sql を一時的に修正

```sql
SELECT
    c_custkey AS customer_id,
    {{ clean_string('c_name') }} AS customer_name,
    c_nationkey AS nation_id,
    c_acctbal AS account_balance,
    {{ clean_string('c_mktsegment') }} AS market_segment
FROM {{ source('tpch', 'customer') }}
```

```bash
dbt compile --select stg_customers --project-dir hands-on/dbt/dbt_learn
```

展開結果：

```sql
SELECT
    c_custkey AS customer_id,
    UPPER(TRIM(c_name)) AS customer_name,
    ...
```

> **学び**: マクロにより変換ロジックを一箇所で管理でき、全モデルで統一できる。

---

## Step 7: dbt_utils パッケージを使う（オプション）

よく使うマクロが集まったコミュニティパッケージ。

> **やること**: `hands-on/dbt/dbt_learn/packages.yml` を新規作成する。

```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: [">=1.0.0", "<2.0.0"]
```

```bash
dbt deps --project-dir hands-on/dbt/dbt_learn
```

### 使用例: surrogate_key

```sql
SELECT
    {{ dbt_utils.generate_surrogate_key(['order_id', 'line_number']) }} AS line_item_key,
    order_id,
    line_number
FROM {{ ref('stg_line_items') }}
```

> dbt_utils には他にも `star()`, `date_spine()`, `pivot()` 等がある。

---

## Step 8: compile 結果をまとめて確認する

```bash
dbt compile --project-dir hands-on/dbt/dbt_learn
```

全モデルの展開後 SQL が `target/compiled/` に出力される。  
気になるモデルのファイルを開いて、Jinja がどう展開されたか確認してみよう。

---

## Step 9: 片付け — 実験用モデルを整理

不要なら以下を削除：
- `models/marts/recent_orders.sql`
- `models/marts/order_status_pivot.sql`

残しておいても OK（テストやドキュメントは未定義だが動作する）。

---

## 確認クイズ

1. `{{ }}` と `{% %}` の違いは？
2. `var("start_date", "1998-01-01")` の第2引数は何？
3. for ループで `{% if not loop.last %},{% endif %}` が必要な理由は？
4. マクロと通常の SQL の違いは？

<details>
<summary>答えを見る</summary>

1. `{{ }}` = 値を SQL に埋め込む。`{% %}` = 制御構文を実行する（出力しない）
2. デフォルト値。`--vars` で上書きされなかったときに使われる
3. SQL の最後のカラムの後にカンマがあると構文エラーになるため、最後の要素だけカンマを付けない
4. マクロは `macros/` に定義して複数モデルから呼び出せる再利用可能な関数

</details>

---

## このレッスンで作ったもの

- [x] `var()` で変数を使い、コマンドラインで上書き
- [x] `{% if target.name == 'dev' %}` で環境切り替え
- [x] `{% for %}` でループによる動的 SQL 生成
- [x] `macros/clean_string.sql` でカスタムマクロ作成
- [x] `dbt compile` で全ての展開結果を確認

---

## 演習問題

→ [演習 1: clean_string マクロを適用する](exercises/lesson_06/exercise_01.md)  
→ [演習 2: for ループで return_flag 別の集計を行う](exercises/lesson_06/exercise_02.md)

---

## 次のレッスン

→ [Lesson 7: デプロイして本番運用する](lesson_07_deploy_and_schedule.md)
