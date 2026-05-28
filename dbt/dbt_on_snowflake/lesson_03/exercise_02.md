# Lesson 3 — 演習 2: fct_orders に地域名を追加する

> **難易度**: ★★☆ 応用  
> **目的**: ref() を使ってモデル間を結合し、DAG を拡張できることを確認する

---

## 問題

演習 1 で作成した `stg_regions` を使い、`fct_orders` に `region_name`（地域名）を追加せよ。

### 要件

1. ファイル: `dbt/dbt_learn/models/marts/fct_orders.sql` を修正する（または新規に `fct_orders_v2.sql` を作成）
2. `stg_nations` には `region_id` がある → `stg_regions` と結合して `region_name` を取得
3. 既存のカラムは全て維持すること

### 結合のヒント

```
stg_orders → stg_customers → stg_nations → stg_regions
                (customer_id)   (nation_id)   (region_id)
```

---

## 検証手順

```bash
# 1. 上流を含めて実行
dbt run --select +fct_orders --project-dir dbt/dbt_learn

# 2. 結果確認（SQL Worksheet）
SELECT DISTINCT region_name FROM DBT_LEARN.ANALYTICS.FCT_ORDERS ORDER BY region_name;
```

### 期待する結果

5つの地域名が返る:
- AFRICA
- AMERICA
- ASIA
- EUROPE
- MIDDLE EAST

---

## 発展課題（任意）

地域別の売上集計を確認：

```sql
SELECT
    region_name,
    COUNT(*) AS order_count,
    ROUND(SUM(total_price), 2) AS total_revenue
FROM DBT_LEARN.ANALYTICS.FCT_ORDERS
GROUP BY region_name
ORDER BY total_revenue DESC;
```

---

模範解答 → [answers/fct_orders_with_region.sql](answers/fct_orders_with_region.sql)
