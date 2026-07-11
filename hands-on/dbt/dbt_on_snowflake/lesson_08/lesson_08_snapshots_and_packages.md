# Lesson 8: Snapshot で変更履歴を追跡する & パッケージ活用

> **所要時間**: 35分  
> **形式**: Snapshot を作成して SCD Type 2 を体験 + dbt パッケージで高度なテストを導入

---

## ゴール

このレッスンを終えると：
- Snapshot（SCD Type 2）の仕組みと使い所が分かる
- `dbt snapshot` コマンドを使って変更履歴テーブルを作れる
- dbt パッケージ（`dbt_utils`）をインストールして活用できる
- surrogate key やカスタムジェネリックテストを使える

---

## 背景: なぜ変更履歴が必要か

> **シナリオ**: 顧客の `market_segment` が営業活動によって変わることがある。  
> 「この顧客は **いつ** セグメントが変更されたか？」を追跡したい。

通常のテーブルやビューでは **最新の状態しか見えない**。  
Snapshot を使えば、変更のたびに新しいレコードが追加され、履歴が残る。

```
┌─────────────┬──────────────┬────────────┬────────────┐
│ customer_id │ segment      │ valid_from │ valid_to   │
├─────────────┼──────────────┼────────────┼────────────┤
│ 12345       │ AUTOMOBILE   │ 2024-01-01 │ 2024-06-15 │
│ 12345       │ MACHINERY    │ 2024-06-15 │ NULL       │  ← 現在有効
└─────────────┴──────────────┴────────────┴────────────┘
```

---

## Step 1: Snapshot 用スキーマを作成する

> **やること**: SQL Worksheet で以下を実行する。

```sql
CREATE SCHEMA IF NOT EXISTS DBT_LEARN.SNAPSHOTS;
```

---

## Step 2: Snapshot ファイルを作成する

> **やること**: `hands-on/dbt/dbt_learn/snapshots/snap_customers.sql` を作成する。

```sql
{% snapshot snap_customers %}

{{
    config(
        target_database='DBT_LEARN',
        target_schema='SNAPSHOTS',
        unique_key='customer_id',
        strategy='check',
        check_cols=['market_segment', 'account_balance']
    )
}}

SELECT
    customer_id,
    customer_name,
    market_segment,
    account_balance,
    nation_id
FROM {{ ref('stg_customers') }}

{% endsnapshot %}
```

### 設計のポイント

| 設定 | 意味 |
|------|------|
| `unique_key` | 各レコードを一意に特定するカラム |
| `strategy='check'` | 指定カラムの値が変わったら新レコード追加 |
| `check_cols` | 変更を監視するカラム一覧 |
| `target_schema` | Snapshot テーブルの出力先 |

> **もう1つの strategy**: `timestamp` — `updated_at` カラムがある場合はこちらが軽量。

---

## Step 3: Snapshot を初回実行する

```bash
dbt snapshot --project-dir hands-on/dbt/dbt_learn
```

### 期待する結果

```
Completed successfully

Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1
```

---

## Step 4: 結果を SQL で確認する

> **やること**: SQL Worksheet で以下を実行する。

```sql
-- 4-1: Snapshot テーブルの構造を確認
DESCRIBE TABLE DBT_LEARN.SNAPSHOTS.SNAP_CUSTOMERS;
```

**確認ポイント**: dbt が自動追加したメタカラムに注目：
- `DBT_SCD_ID` — レコードの一意ID
- `DBT_UPDATED_AT` — 変更検知日時
- `DBT_VALID_FROM` — このレコードが有効になった日時
- `DBT_VALID_TO` — このレコードが無効になった日時（NULL = 現在有効）

```sql
-- 4-2: データを確認
SELECT customer_id, customer_name, market_segment, account_balance,
       dbt_valid_from, dbt_valid_to
FROM DBT_LEARN.SNAPSHOTS.SNAP_CUSTOMERS
ORDER BY customer_id
LIMIT 20;
```

> **チェックポイント**: 全レコードの `dbt_valid_to` が NULL（初回なので全て「現在有効」）。

---

## Step 5: 変更をシミュレートする

実際にソースデータを変えて Snapshot が履歴を追跡する様子を見よう。

> **やること**: 変更をシミュレートするためのテーブルを作成する。

```sql
-- 5-1: stg_customers のスナップショット元としてシミュレート用テーブルを作成
CREATE OR REPLACE TABLE DBT_LEARN.ANALYTICS.CUSTOMER_SIMULATION AS
SELECT
    C_CUSTKEY AS customer_id,
    C_NAME AS customer_name,
    C_MKTSEGMENT AS market_segment,
    C_ACCTBAL AS account_balance,
    C_NATIONKEY AS nation_id
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER
LIMIT 100;
```

```sql
-- 5-2: 一部の顧客のセグメントを変更する
UPDATE DBT_LEARN.ANALYTICS.CUSTOMER_SIMULATION
SET market_segment = 'MACHINERY'
WHERE customer_id IN (1, 2, 3);
```

```sql
-- 5-3: 変更を確認
SELECT customer_id, customer_name, market_segment
FROM DBT_LEARN.ANALYTICS.CUSTOMER_SIMULATION
WHERE customer_id IN (1, 2, 3);
```

---

## Step 6: シミュレーション用 Snapshot を作成・実行する

> **やること**: `hands-on/dbt/dbt_learn/snapshots/snap_customers_sim.sql` を作成する。

```sql
{% snapshot snap_customers_sim %}

{{
    config(
        target_database='DBT_LEARN',
        target_schema='SNAPSHOTS',
        unique_key='customer_id',
        strategy='check',
        check_cols=['market_segment', 'account_balance']
    )
}}

SELECT
    customer_id,
    customer_name,
    market_segment,
    account_balance,
    nation_id
FROM DBT_LEARN.ANALYTICS.CUSTOMER_SIMULATION

{% endsnapshot %}
```

```bash
# 初回実行
dbt snapshot --select snap_customers_sim --project-dir hands-on/dbt/dbt_learn
```

次に、追加の変更を加えて再実行する：

```sql
-- さらにセグメントを変更
UPDATE DBT_LEARN.ANALYTICS.CUSTOMER_SIMULATION
SET market_segment = 'BUILDING'
WHERE customer_id = 1;

UPDATE DBT_LEARN.ANALYTICS.CUSTOMER_SIMULATION
SET account_balance = 9999.99
WHERE customer_id = 2;
```

```bash
# 2回目の実行 — 変更を検知して履歴レコードが追加される
dbt snapshot --select snap_customers_sim --project-dir hands-on/dbt/dbt_learn
```

---

## Step 7: 履歴を確認する

```sql
SELECT customer_id, market_segment, account_balance,
       dbt_valid_from, dbt_valid_to
FROM DBT_LEARN.SNAPSHOTS.SNAP_CUSTOMERS_SIM
WHERE customer_id IN (1, 2)
ORDER BY customer_id, dbt_valid_from;
```

> **チェックポイント**:
> - customer_id = 1 は **2行**（MACHINERY → BUILDING の変遷）
> - customer_id = 2 は **2行**（balance 変更による新レコード）
> - 古いレコードの `dbt_valid_to` には次のレコードの `dbt_valid_from` が入っている

---

## Step 8: dbt パッケージを導入する

dbt にはコミュニティ製パッケージがあり、便利なマクロやテストを追加できる。

> **やること**: `hands-on/dbt/dbt_learn/packages.yml` を作成する。

```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: [">=1.0.0", "<2.0.0"]
```

```bash
# パッケージをインストール
dbt deps --project-dir hands-on/dbt/dbt_learn
```

### 期待する結果

```
Installing dbt-labs/dbt_utils
  Installed from version 1.x.x
```

---

## Step 9: dbt_utils の surrogate_key を使う

> **やること**: `hands-on/dbt/dbt_learn/models/marts/fct_line_items_v2.sql` を作成する。

```sql
{{
    config(
        materialized='table'
    )
}}

SELECT
    {{ dbt_utils.generate_surrogate_key(['li.line_item_key', 'li.order_id']) }} AS line_item_sk,
    li.line_item_key,
    li.order_id,
    li.part_key,
    li.supplier_key,
    li.quantity,
    li.extended_price,
    li.discount_amount,
    li.tax_amount,
    li.ship_date,
    o.order_date,
    o.order_status
FROM {{ ref('stg_line_items') }} li
JOIN {{ ref('stg_orders') }} o
    ON li.order_id = o.order_id
```

```bash
# compile で生成 SQL を確認
dbt compile --select fct_line_items_v2 --project-dir hands-on/dbt/dbt_learn
```

> **確認ポイント**: `generate_surrogate_key` が MD5 ハッシュの SQL に展開されることを確認。

---

## Step 10: dbt_utils のテストを活用する

> **やること**: `hands-on/dbt/dbt_learn/models/marts/marts.yml` に以下のテストを追加する。

```yaml
  - name: fct_line_items_v2
    description: "注文明細ファクト（サロゲートキー付き）"
    columns:
      - name: line_item_sk
        description: "サロゲートキー"
        tests:
          - not_null
          - unique

      - name: extended_price
        tests:
          - dbt_utils.accepted_range:
              min_value: 0
              inclusive: true

      - name: quantity
        tests:
          - dbt_utils.accepted_range:
              min_value: 1
              max_value: 50
```

```bash
# モデル作成 + テスト実行
dbt build --select fct_line_items_v2 --project-dir hands-on/dbt/dbt_learn
```

---

## Step 11: 実験 — テストを故意に失敗させる

> **やること**: accepted_range の上限を故意に厳しくして FAIL を観察する。

`marts.yml` の `quantity` テストを一時的に変更：

```yaml
      - name: quantity
        tests:
          - dbt_utils.accepted_range:
              min_value: 1
              max_value: 10    # ← 実データでは50まであるので FAIL するはず
```

```bash
dbt test --select fct_line_items_v2 --project-dir hands-on/dbt/dbt_learn
```

> **確認ポイント**: `FAIL` になること。エラーメッセージに「10を超える行数」が表示される。

実験後、`max_value` を `50` に戻しておく。

---

## まとめ

| 学んだこと | キーワード |
|-----------|-----------|
| 変更履歴の追跡 | `dbt snapshot`, SCD Type 2 |
| 監視対象の指定 | `strategy`, `check_cols`, `unique_key` |
| パッケージ管理 | `packages.yml`, `dbt deps` |
| サロゲートキー生成 | `dbt_utils.generate_surrogate_key` |
| 高度な範囲テスト | `dbt_utils.accepted_range` |

---

## 確認クイズ

1. `strategy='check'` と `strategy='timestamp'` の違いは？
2. Snapshot テーブルで「現在有効なレコード」を取得するにはどの条件を使う？
3. `dbt deps` は何をするコマンド？
4. `generate_surrogate_key` は内部的に何の関数を使っている？

<details>
<summary>答えを見る</summary>

1. `check` = 指定カラムの値変化を比較して検知。`timestamp` = `updated_at` カラムの日時で判定（比較が軽量）
2. `WHERE dbt_valid_to IS NULL`
3. `packages.yml` に記載されたパッケージをダウンロード・インストールする
4. MD5 ハッシュ関数（複数カラムを結合してハッシュ化）

</details>

---

## 演習問題

→ [演習 1: Snapshot の Strategy 変更](exercise_01.md)  
→ [演習 2: dbt_utils で独自テストを組み合わせる](exercise_02.md)

---

## 次のレッスン

→ [Lesson 9: hooks・tags・セレクタで運用を効率化する](../lesson_09/lesson_09_hooks_tags_selectors.md)
