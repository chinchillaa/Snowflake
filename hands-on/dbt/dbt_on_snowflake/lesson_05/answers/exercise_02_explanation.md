# 演習 2 模範解答: stg_line_items テスト定義

## Part A: YAML テスト

`staging.yml` の stg_line_items セクションに以下を追加（既存定義に追記）：

```yaml
  - name: stg_line_items
    description: "注文明細の staging モデル"
    columns:
      - name: order_id
        description: "注文ID"
        tests:
          - not_null
      - name: line_number
        description: "明細行番号"
        tests:
          - not_null
      - name: quantity
        description: "数量"
        tests:
          - not_null
      - name: discount
        description: "割引率（0〜1）"
        tests:
          - not_null
      - name: extended_price
        description: "小計金額"
        tests:
          - not_null
```

> **注**: `[order_id, line_number]` の複合ユニーク制約は generic テストだけでは表現しにくい。  
> `dbt_utils.unique_combination_of_columns` を使うか、singular テストで実装する。

### 複合ユニークの singular テスト（代替案）

```sql
-- tests/assert_line_item_unique_key.sql
SELECT
    order_id,
    line_number,
    COUNT(*) AS cnt
FROM {{ ref('stg_line_items') }}
GROUP BY order_id, line_number
HAVING COUNT(*) > 1
```

## Part B: singular テスト

- `assert_line_item_quantity_positive.sql` → [こちら](assert_line_item_quantity_positive.sql)
- `assert_discount_in_range.sql` → [こちら](assert_discount_in_range.sql)

## 考察の解答

### YAML テスト vs SQL テスト

| 種別 | 適している場面 |
|------|--------------|
| YAML (generic) | NULL チェック、一意性、許可リスト、外部キー |
| SQL (singular) | 範囲チェック、複合条件、計算値の検証、テーブル横断の整合性 |

### 範囲チェックを YAML だけで行う方法

標準の dbt には範囲テストがないが、`dbt_expectations` パッケージを使えば可能：

```yaml
      - name: discount
        tests:
          - dbt_expectations.expect_column_values_to_be_between:
              min_value: 0
              max_value: 1
```
