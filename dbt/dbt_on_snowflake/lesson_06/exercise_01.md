# Lesson 6 — 演習 1: clean_string マクロを適用する

> **難易度**: ★★☆ 応用  
> **目的**: 自作マクロをモデルに適用し、compile で展開結果を確認する

---

## 問題

Lesson 6 で作成した `clean_string` マクロを使い、`stg_customers` の `customer_name` と `market_segment` を正規化するバージョンを作成せよ。

### 要件

1. ファイル: `dbt/dbt_learn/models/staging/stg_customers_clean.sql` を新規作成
2. `clean_string` マクロ（`UPPER(TRIM(...))`）を `customer_name` と `market_segment` に適用
3. 他のカラムはそのまま

### ヒント

- `macros/clean_string.sql` は既に以下で定義済み:
  ```sql
  {% macro clean_string(column_name) %}
      UPPER(TRIM({{ column_name }}))
  {% endmacro %}
  ```
- `{{ clean_string('c_name') }}` のように呼び出す

---

## 検証手順

```bash
# 1. compile で展開結果を確認
dbt compile --select stg_customers_clean --project-dir dbt/dbt_learn

# 2. 展開結果を読む
# target/compiled/.../stg_customers_clean.sql に以下が含まれるはず:
# UPPER(TRIM(c_name)) AS customer_name

# 3. 実行
dbt run --select stg_customers_clean --project-dir dbt/dbt_learn

# 4. SQL で確認
```

```sql
SELECT customer_name, market_segment
FROM DBT_LEARN.ANALYTICS.STG_CUSTOMERS_CLEAN
LIMIT 5;
```

### 期待する結果

- 全ての `customer_name` が大文字（既にそうかもしれないが、先頭/末尾の空白が除去されている）
- 全ての `market_segment` が大文字で空白なし

---

## 発展: マクロを拡張する

`clean_string` を拡張して `NULL` の場合にデフォルト値を返すバージョンを作ってみよう:

```sql
{% macro clean_string_with_default(column_name, default_value='UNKNOWN') %}
    COALESCE(UPPER(TRIM({{ column_name }})), '{{ default_value }}')
{% endmacro %}
```

---

模範解答 → [answers/stg_customers_clean.sql](answers/stg_customers_clean.sql)
