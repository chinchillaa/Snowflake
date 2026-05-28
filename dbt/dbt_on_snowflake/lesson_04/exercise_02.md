# Lesson 4 — 演習 2: incremental モデルのロジック変更

> **難易度**: ★★★ 分析  
> **目的**: incremental モデル変更時に --full-refresh が必要な理由を体感する

---

## 問題

`fct_line_items` の `net_price` 計算ロジックを変更し、`--full-refresh` なしとありの違いを確認せよ。

### 手順

#### Phase A: 現在の net_price を確認

```sql
SELECT order_id, line_number, extended_price, discount, tax, net_price
FROM DBT_LEARN.ANALYTICS.FCT_LINE_ITEMS
WHERE order_id = 1
ORDER BY line_number;
```

結果をメモしておく。

#### Phase B: 計算ロジックを変更

`fct_line_items.sql` の `net_price` の計算を以下に変更：

```sql
-- 変更前: li.extended_price * (1 - li.discount) * (1 + li.tax) AS net_price
-- 変更後:
li.extended_price * (1 - li.discount) AS net_price  -- tax を除外
```

#### Phase C: --full-refresh なしで実行

```bash
dbt run --select fct_line_items --project-dir dbt/dbt_learn
```

```sql
-- 再度確認
SELECT order_id, line_number, extended_price, discount, tax, net_price
FROM DBT_LEARN.ANALYTICS.FCT_LINE_ITEMS
WHERE order_id = 1
ORDER BY line_number;
```

**質問**: net_price は変わったか？なぜ？

#### Phase D: --full-refresh ありで実行

```bash
dbt run --select fct_line_items --full-refresh --project-dir dbt/dbt_learn
```

```sql
-- 再度確認
SELECT order_id, line_number, extended_price, discount, tax, net_price
FROM DBT_LEARN.ANALYTICS.FCT_LINE_ITEMS
WHERE order_id = 1
ORDER BY line_number;
```

**質問**: 今度は net_price が変わったか？

#### Phase E: 元に戻す

計算式を元に戻す：

```sql
li.extended_price * (1 - li.discount) * (1 + li.tax) AS net_price
```

```bash
dbt run --select fct_line_items --full-refresh --project-dir dbt/dbt_learn
```

---

## レポート

| フェーズ | net_price (order_id=1, line_number=1) | 変化した？ |
|---------|--------------------------------------|-----------|
| A (変更前) | _________ | - |
| C (refresh なし) | _________ | Yes / No |
| D (refresh あり) | _________ | Yes / No |

### 考察

- Phase C で値が変わらない理由を説明せよ
- `--full-refresh` を忘れるとどんな問題が起きるか？

---

模範解答 → [answers/exercise_02_report.md](answers/exercise_02_report.md)
