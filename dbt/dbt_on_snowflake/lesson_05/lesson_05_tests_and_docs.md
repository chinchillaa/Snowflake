# Lesson 5: テストでデータ品質を守る

> **所要時間**: 25分  
> **形式**: テストを書く → 通す → わざと壊す → 修正する、のサイクルを体験

---

## ゴール

このレッスンを終えると：
- YAML でテスト（not_null, unique, accepted_values, relationships）を書ける
- SQL ファイルでカスタムテスト（singular test）を書ける
- `dbt test` と `dbt build` の違いが分かる
- テスト失敗時の挙動を理解している

---

## Step 1: テストの基本を理解する

dbt テストの原則: **「SQL が0行返せば PASS、1行以上返せば FAIL」**

例: 「order_id が NULL のレコードがあるか？」

```sql
-- これが0行を返す → テストPASS（NULLが無い = 品質OK）
SELECT order_id FROM stg_orders WHERE order_id IS NULL
```

dbt はこの仕組みを YAML 1行で書けるようにしている。

---

## Step 2: staging.yml にテストを追加する

> **やること**: `dbt/dbt_learn/models/staging/staging.yml` を確認する。

```yaml
version: 2

models:
  - name: stg_orders
    description: "注文ヘッダーの staging モデル"
    columns:
      - name: order_id
        description: "注文ID（主キー）"
        tests:
          - not_null
          - unique

      - name: customer_id
        description: "顧客ID（外部キー）"
        tests:
          - not_null
          - relationships:
              to: ref('stg_customers')
              field: customer_id

      - name: order_status
        description: "注文ステータス（F=完了, O=未処理, P=一部処理）"
        tests:
          - accepted_values:
              values: ['F', 'O', 'P']

      - name: total_price
        description: "注文合計金額"
        tests:
          - not_null
```

### 4つの組み込みテスト

| テスト | 検証内容 | 生成される SQL（イメージ） |
|--------|---------|--------------------------|
| `not_null` | NULL がない | `WHERE column IS NULL` |
| `unique` | 重複がない | `GROUP BY column HAVING COUNT(*) > 1` |
| `accepted_values` | 特定値のみ | `WHERE column NOT IN (...)` |
| `relationships` | 外部キー整合性 | `WHERE column NOT IN (SELECT field FROM to)` |

---

## Step 3: テストを実行する

```bash
dbt test --select stg_orders --project-dir dbt/dbt_learn
```

### 期待する結果

```
Completed successfully
Done. PASS=5 WARN=0 ERROR=0 SKIP=0 TOTAL=5
```

5つのテスト全て PASS。

---

## Step 4: 【実験】テストを故意に失敗させる

> **やること**: `accepted_values` の値リストをわざと不完全にしてみる。

`staging.yml` の order_status のテストを一時的に変更：

```yaml
      - name: order_status
        tests:
          - accepted_values:
              values: ['F', 'O']    # 'P' を消す
```

```bash
dbt test --select stg_orders --project-dir dbt/dbt_learn
```

### 期待する結果

```
FAIL 1  accepted_values_stg_orders_order_status__F__O

Completed with 1 error
Done. PASS=4 WARN=0 ERROR=1 SKIP=0 TOTAL=5
```

> **学び**: テストが FAIL すると、ステータス 'P' のデータが存在するのに許可リストにないことを検出した。

**元に戻す**: `values: ['F', 'O', 'P']` に戻す。

---

## Step 5: Singular テスト（カスタム SQL テスト）を書く

YAML テストでは表現できない複雑なルールは SQL ファイルで書く。

> **やること**: `dbt/dbt_learn/tests/assert_total_price_positive.sql` を確認する。

```sql
SELECT
    order_id,
    total_price
FROM {{ ref('stg_orders') }}
WHERE total_price <= 0
```

**ルール**: このクエリが **0行** 返す → PASS、**1行以上** → FAIL

```bash
dbt test --select assert_total_price_positive --project-dir dbt/dbt_learn
```

> PASS するはず（TPC-H データには total_price <= 0 のレコードがない）。

---

## Step 6: 自分で singular テストを書いてみよう

> **やること**: 以下のファイルを新規作成する。

`dbt/dbt_learn/tests/assert_order_date_reasonable.sql`:

```sql
SELECT
    order_id,
    order_date
FROM {{ ref('stg_orders') }}
WHERE order_date < '1990-01-01'
   OR order_date > CURRENT_DATE()
```

これは「注文日が 1990年より前、または未来の日付がないこと」を検証する。

```bash
dbt test --select assert_order_date_reasonable --project-dir dbt/dbt_learn
```

> PASS するはず。

---

## Step 7: dbt build を体験する

`dbt build` = `dbt run` + `dbt test` を依存順で交互に実行：

```bash
dbt build --select +fct_orders --project-dir dbt/dbt_learn
```

### 実行順序

```
1. stg_orders を run（ビュー作成）
2. stg_orders のテストを実行 ← PASS なら次へ
3. stg_customers を run
4. stg_customers のテストを実行
5. stg_nations を run
6. stg_nations のテストを実行
7. fct_orders を run（テーブル作成）
8. fct_orders のテストを実行
```

> **重要**: もし Step 2 でテスト FAIL → Step 7 以降は **SKIP** される。  
> データ品質の問題が下流に伝播しない！

---

## Step 8: 【実験】テスト失敗時の下流 SKIP を確認

> **やること**: `staging.yml` の `stg_orders.order_id` のテストに、必ず失敗するテストを追加。

```yaml
      - name: order_id
        tests:
          - not_null
          - unique
          - accepted_values:        # ← わざと追加（order_id は数値なので必ず FAIL）
              values: ['DUMMY']
```

```bash
dbt build --select +fct_orders --project-dir dbt/dbt_learn
```

### 期待する結果

```
FAIL accepted_values_stg_orders_order_id__DUMMY
SKIP fct_orders (depends on stg_orders)

Done. PASS=X WARN=0 ERROR=1 SKIP=1
```

> **学び**: テスト失敗でパイプラインが自動停止する = 安全装置。

**元に戻す**: 追加した `accepted_values` テストを削除。

---

## Step 9: Mart モデルにもテストを追加する

> **やること**: `dbt/dbt_learn/models/marts/marts.yml` を確認する。

```yaml
version: 2

models:
  - name: fct_orders
    description: "注文ファクトテーブル。顧客・国情報を結合済み"
    columns:
      - name: order_id
        description: "注文ID"
        tests:
          - not_null
          - unique
      - name: total_price
        description: "注文合計金額"
        tests:
          - not_null

  - name: dim_customers
    description: "顧客ディメンション。生涯価値・注文回数を含む"
    columns:
      - name: customer_id
        description: "顧客ID"
        tests:
          - not_null
          - unique
```

---

## Step 10: 全テストを実行する

```bash
dbt test --project-dir dbt/dbt_learn
```

全テスト PASS を確認。

---

## Step 11: ドキュメント — description の活用

テスト定義と同じ YAML に `description` を書くだけでドキュメントになる。

ドキュメントを生成するには：

```bash
dbt docs generate --project-dir dbt/dbt_learn
```

> これにより `target/catalog.json` が作成される。  
> デプロイ後は Snowflake のデータカタログに連携される。

---

## 確認クイズ

1. `dbt test` と `dbt build` の違いは？
2. singular テストが PASS する条件は？
3. `relationships` テストは何を検証している？
4. upstream のテストが FAIL した場合、downstream のモデルはどうなる？

<details>
<summary>答えを見る</summary>

1. `dbt test` = テストのみ実行。`dbt build` = run と test を依存順で交互に実行
2. SQL クエリの結果が **0行** であること
3. あるカラムの値が、参照先テーブルの指定カラムに全て存在すること（外部キー整合性）
4. **SKIP** される（実行されない）

</details>

---

## このレッスンで作ったもの

- [x] staging.yml にテスト定義を追加（not_null, unique, accepted_values, relationships）
- [x] marts.yml にテスト定義を追加
- [x] singular テスト（assert_total_price_positive, assert_order_date_reasonable）
- [x] テスト失敗時の挙動を実験で確認
- [x] `dbt build` で run + test の一括実行を確認

---

## 演習問題

→ [演習 1: dim_customers の singular テストを作成する](exercises/lesson_05/exercise_01.md)  
→ [演習 2: stg_line_items のテスト定義を作成する](exercises/lesson_05/exercise_02.md)

---

## 次のレッスン

→ [Lesson 6: Jinja テンプレートとマクロ](lesson_06_jinja_and_macros.md)
