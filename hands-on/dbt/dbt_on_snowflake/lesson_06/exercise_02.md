# Lesson 6 — 演習 2: for ループで return_flag 別の集計を行う

> **難易度**: ★★★ 発展  
> **目的**: for ループを使った動的 SQL 生成をマスターする

---

## 問題

`stg_line_items` の `return_flag` カラムには 3つの値がある: `'R'`, `'A'`, `'N'`。

for ループを使い、**顧客ごとに各 return_flag の件数と合計金額を横持ち（ピボット）で出力する**モデルを作成せよ。

### 要件

1. ファイル: `hands-on/dbt/dbt_learn/models/marts/customer_return_summary.sql` を新規作成
2. Jinja の `{% set %}` と `{% for %}` を使用
3. 出力カラム:
   - `customer_id`
   - `total_line_items`（全件数）
   - `flag_R_count`, `flag_A_count`, `flag_N_count`（各フラグの件数）
   - `flag_R_amount`, `flag_A_amount`, `flag_N_amount`（各フラグの合計金額）
4. `loop.last` を使ってカンマを制御すること

### ヒント

```sql
{% set flags = ['R', 'A', 'N'] %}

SELECT
    -- ここに for ループ
FROM {{ ref('stg_line_items') }} li
JOIN {{ ref('stg_orders') }} o ON li.order_id = o.order_id
GROUP BY o.customer_id
```

---

## 検証手順

```bash
# 1. compile で展開を確認
dbt compile --select customer_return_summary --project-dir hands-on/dbt/dbt_learn

# 2. 展開後の SQL に以下のようなカラムがあることを確認:
# COUNT(CASE WHEN li.return_flag = 'R' THEN 1 END) AS flag_R_count
# SUM(CASE WHEN li.return_flag = 'R' THEN li.extended_price ELSE 0 END) AS flag_R_amount
# ... (A, N も同様)

# 3. 実行
dbt run --select customer_return_summary --project-dir hands-on/dbt/dbt_learn
```

```sql
-- 結果確認
SELECT * FROM DBT_LEARN.ANALYTICS.CUSTOMER_RETURN_SUMMARY LIMIT 10;

-- R（返品）の件数が多い顧客 TOP 5
SELECT customer_id, flag_R_count, flag_R_amount
FROM DBT_LEARN.ANALYTICS.CUSTOMER_RETURN_SUMMARY
ORDER BY flag_R_count DESC
LIMIT 5;
```

---

## 発展課題

返品率（`flag_R_count / total_line_items`）が高い顧客 TOP 10 を抽出するクエリを書いてみよう。

---

模範解答 → [answers/customer_return_summary.sql](answers/customer_return_summary.sql)
