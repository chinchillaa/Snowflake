# 演習 2 模範解答: fct_orders への dbt_utils テスト追加

`dbt/dbt_learn/models/marts/marts.yml` の `fct_orders` セクションに以下を追加：

```yaml
  - name: fct_orders
    description: "注文ファクトテーブル"
    tests:
      - dbt_utils.expression_is_true:
          expression: "total_price > 0"
    columns:
      - name: order_id
        tests:
          - not_null
          - unique

      - name: total_price
        tests:
          - not_null
          - dbt_utils.accepted_range:
              min_value: 0
              max_value: 1000000
              inclusive: true

      - name: order_date
        tests:
          - not_null
          - dbt_utils.accepted_range:
              min_value: "'1992-01-01'"
              max_value: "'1998-12-31'"

      - name: order_status
        tests:
          - accepted_values:
              values: ['F', 'O', 'P']
```

## 解説

- `expression_is_true` はモデルレベル（`tests:` 直下）に書く
- `accepted_range` の日付リテラルはシングルクォートで囲む（SQL として展開されるため）
- `inclusive: true` はデフォルトなので省略可能だが、明示すると可読性が上がる
