# Lesson 9 — 演習 1: カスタムログマクロを作成する

> **難易度**: ★★☆ 応用  
> **目的**: マクロと hook を組み合わせて再利用可能なログ機構を作る

---

## 問題

モデル名と実行開始時刻を自動記録するマクロを作成し、複数モデルで再利用せよ。

### 要件

1. ファイル: `hands-on/dbt/dbt_learn/macros/log_model_run.sql`
2. マクロ名: `log_model_run`
3. 引数: `model_name`（文字列）
4. 機能: `DBT_LEARN.ANALYTICS.DBT_RUN_LOG` に INSERT する SQL 文を **返す**
5. このマクロを `fct_orders` と `dim_customers` の `pre_hook` で使用する

### ヒント

- マクロは SQL 文字列を返すだけでよい（実行は hook が行う）
- 使い方のイメージ:
  ```sql
  {{
      config(
          materialized='table',
          pre_hook="{{ log_model_run('fct_orders') }}"
      )
  }}
  ```
- マクロ内では Jinja テンプレートとして文字列を組み立てる

---

## 検証手順

```bash
# 1. compile で展開を確認
dbt compile --select fct_orders --project-dir hands-on/dbt/dbt_learn

# 2. 実行
dbt run --select fct_orders dim_customers --project-dir hands-on/dbt/dbt_learn

# 3. ログ確認
```

```sql
SELECT * FROM DBT_LEARN.ANALYTICS.DBT_RUN_LOG
WHERE model_name IN ('fct_orders', 'dim_customers')
ORDER BY started_at DESC;
```

### 期待する結果

- 2行のログレコードが記録されている
- `model_name` が正しく入っている

---

## 発展: this.name を使って自動化する

マクロの引数を省略し、`{{ this.name }}` でモデル名を自動取得する方法もある：

```sql
{% macro log_model_run_auto() %}
INSERT INTO DBT_LEARN.ANALYTICS.DBT_RUN_LOG (model_name) VALUES ('{{ this.name }}')
{% endmacro %}
```

> **注意**: `{{ this }}` は hook のコンテキストでのみ利用可能。

---

模範解答 → [answers/log_model_run.sql](answers/log_model_run.sql)
