# Lesson 3 — 演習 1: stg_regions モデルを作成する

> **難易度**: ★☆☆ 基本  
> **目的**: source() を使って新しい staging モデルを自分で書けることを確認する

---

## 問題

TPC-H データセットには `REGION` テーブル（5地域）がある。  
これを staging モデルとして `stg_regions.sql` を作成せよ。

### 要件

1. ファイル: `dbt/dbt_learn/models/staging/stg_regions.sql`
2. ソース: `{{ source('tpch', 'region') }}`
3. カラムのリネーム:
   - `R_REGIONKEY` → `region_id`
   - `R_NAME` → `region_name`
   - `R_COMMENT` → `region_comment`

### ヒント

- `sources.yml` に `region` は既に定義済み
- 既存の `stg_nations.sql` を参考にするとよい

---

## 検証手順

```bash
# 1. コンパイルできることを確認
dbt compile --select stg_regions --project-dir dbt/dbt_learn

# 2. 実行
dbt run --select stg_regions --project-dir dbt/dbt_learn

# 3. 結果確認（SQL Worksheet）
SELECT * FROM DBT_LEARN.ANALYTICS.STG_REGIONS;
```

### 期待する結果

5行のデータが返り、カラム名が `REGION_ID`, `REGION_NAME`, `REGION_COMMENT` であること。

---

## できたら次へ

→ [演習 2: fct_orders に地域名を追加する](exercise_02.md)

模範解答が必要な場合 → [answers/stg_regions.sql](answers/stg_regions.sql)
