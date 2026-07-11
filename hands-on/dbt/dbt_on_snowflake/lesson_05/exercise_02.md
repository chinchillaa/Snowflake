# Lesson 5 — 演習 2: stg_line_items のテスト定義を作成する

> **難易度**: ★★☆ 応用  
> **目的**: YAML テスト + singular テストを組み合わせてデータ品質を守る

---

## 問題

`stg_line_items` に対して以下のテストを追加せよ。

### 要件

#### Part A: YAML テスト（staging.yml に追加）

`hands-on/dbt/dbt_learn/models/staging/staging.yml` に stg_line_items のテスト定義がすでに一部あるが、以下を追加：

1. `[order_id, line_number]` の組み合わせが一意であること（dbt_utils の `unique_combination_of_columns` を使わず、方法を考える）
2. `discount` が 0 以上 1 以下であること（`accepted_values` では表現できない → singular テストが必要）

#### Part B: singular テスト

`hands-on/dbt/dbt_learn/tests/assert_line_item_quantity_positive.sql` を作成：
- `quantity` が 0 より大きいことを検証

`hands-on/dbt/dbt_learn/tests/assert_discount_in_range.sql` を作成：
- `discount` が 0 未満、または 1 を超えるレコードがないことを検証

---

## 検証手順

```bash
# 全テストを実行
dbt test --select stg_line_items --project-dir hands-on/dbt/dbt_learn
```

### 期待する結果

全テスト PASS。

---

## 考察

- YAML テスト（generic）と SQL テスト（singular）はどう使い分けるべきか？
- 範囲チェック（0 ≤ x ≤ 1）を YAML だけで実現する方法はあるか？

---

模範解答 → [answers/](answers/) を確認
