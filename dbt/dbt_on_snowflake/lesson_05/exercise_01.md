# Lesson 5 — 演習 1: dim_customers の singular テストを作成する

> **難易度**: ★☆☆ 基本  
> **目的**: singular テスト（SQL ファイル）を自分で書けることを確認する

---

## 問題

`dim_customers` の `lifetime_value` が0以上であることを検証する singular テストを作成せよ。

### 要件

1. ファイル: `dbt/dbt_learn/tests/assert_lifetime_value_non_negative.sql`
2. テスト内容: `lifetime_value < 0` のレコードが存在しないこと
3. テスト結果が **0行** なら PASS

### ヒント

- singular テストの原則: **「SQL が0行返せば PASS」**
- `{{ ref('dim_customers') }}` で dim_customers を参照する
- 「〜であってはならない条件」を WHERE 句に書く

---

## 検証手順

```bash
# テストを実行
dbt test --select assert_lifetime_value_non_negative --project-dir dbt/dbt_learn
```

### 期待する結果

```
PASS assert_lifetime_value_non_negative
Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1
```

---

## 発展: わざと失敗させてみる

テスト条件を `WHERE lifetime_value >= 0` に変えて実行するとどうなる？

→ 全行が返るので FAIL する。テストの書き方（条件の向き）を理解するのに有用。

---

模範解答 → [answers/assert_lifetime_value_non_negative.sql](answers/assert_lifetime_value_non_negative.sql)
