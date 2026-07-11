# Lesson 4 — 演習 1: マテリアライゼーションの切り替え実験

> **難易度**: ★★☆ 実験  
> **目的**: view / table の違いをクエリ時間で体感する

---

## 問題

`dim_customers` モデルのマテリアライゼーションを **view** と **table** で切り替えて、クエリパフォーマンスを比較せよ。

### 手順

#### Phase A: 現状確認（table）

```sql
-- クエリを実行し、Query Profile で実行時間を確認
SELECT market_segment, COUNT(*) AS customer_count, AVG(lifetime_value) AS avg_ltv
FROM DBT_LEARN.ANALYTICS.DIM_CUSTOMERS
GROUP BY market_segment
ORDER BY avg_ltv DESC;
```

実行時間をメモ: ______ ms

#### Phase B: view に変更

`hands-on/dbt/dbt_learn/models/marts/dim_customers.sql` の先頭に追加：

```sql
{{ config(materialized='view') }}
```

```bash
dbt run --select dim_customers --project-dir hands-on/dbt/dbt_learn
```

同じクエリを再実行して時間を比較：

```sql
SELECT market_segment, COUNT(*) AS customer_count, AVG(lifetime_value) AS avg_ltv
FROM DBT_LEARN.ANALYTICS.DIM_CUSTOMERS
GROUP BY market_segment
ORDER BY avg_ltv DESC;
```

実行時間をメモ: ______ ms

#### Phase C: 元に戻す

`{{ config(materialized='view') }}` を削除し：

```bash
dbt run --select dim_customers --project-dir hands-on/dbt/dbt_learn
```

---

## レポート

以下の表を埋めよ：

| 項目 | table | view |
|------|-------|------|
| `dbt run` の時間 | ___ ms | ___ ms |
| SELECT クエリの時間 | ___ ms | ___ ms |
| Snowflake のオブジェクト種別 | BASE TABLE | VIEW |

### 考察

- どちらの `dbt run` が速かったか？なぜか？
- どちらの `SELECT` が速かったか？なぜか？
- `dim_customers` は view と table のどちらが適切か？理由は？

---

模範解答 → [answers/exercise_01_report.md](answers/exercise_01_report.md)
