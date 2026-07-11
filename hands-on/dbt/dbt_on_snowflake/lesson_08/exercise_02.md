# Lesson 8 — 演習 2: dbt_utils のテストを組み合わせて品質を強化する

> **難易度**: ★★★ 発展  
> **目的**: dbt_utils パッケージの複数テストを組み合わせて実用的なデータ品質チェックを構築する

---

## 問題

`fct_orders` モデルに対して、以下の dbt_utils テストを追加せよ。

### 要件

`hands-on/dbt/dbt_learn/models/marts/marts.yml` の `fct_orders` セクションに追加：

1. **total_price** カラム:
   - `dbt_utils.accepted_range` で 0 以上 1,000,000 以下であることを検証

2. **order_date** カラム:
   - `dbt_utils.accepted_range` で `'1992-01-01'` 以降、`'1998-12-31'` 以前であることを検証

3. **order_status** カラム:
   - `accepted_values` テストで `['F', 'O', 'P']` のみであることを検証

4. モデルレベル（columns の外）:
   - `dbt_utils.expression_is_true` で `total_price > 0` が全行で成り立つことを検証

### ヒント

- `dbt_utils.accepted_range` は `min_value`, `max_value`, `inclusive`(default: true) を指定
- `dbt_utils.expression_is_true` はモデル直下の `tests:` に書く:
  ```yaml
  models:
    - name: fct_orders
      tests:
        - dbt_utils.expression_is_true:
            expression: "total_price > 0"
  ```
- 日付の範囲チェックでは文字列をそのまま `min_value` / `max_value` に指定可能

---

## 検証手順

```bash
# テストを実行
dbt test --select fct_orders --project-dir hands-on/dbt/dbt_learn
```

### 期待する結果

```
PASS fct_orders_accepted_range_total_price
PASS fct_orders_accepted_range_order_date
PASS fct_orders_accepted_values_order_status
PASS fct_orders_expression_is_true_total_price_gt_0
Done. PASS=4 WARN=0 ERROR=0 SKIP=0 TOTAL=4
```

---

## 発展: where 句でテスト範囲を絞る

多くの dbt_utils テストは `where` パラメータをサポートしている：

```yaml
- dbt_utils.accepted_range:
    min_value: 0
    where: "order_status = 'F'"  # 完了注文のみ検証
```

> **問い**: テストに `where` を追加するメリットは何か？  
> → 特定の条件下でのみ成り立つルールを検証できる。ノイズを減らして意味のあるテストになる。

---

模範解答 → [answers/exercise_02_marts_yml.md](answers/exercise_02_marts_yml.md)
