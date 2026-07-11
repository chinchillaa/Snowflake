# Lesson 8 — 演習 1: Snapshot の Strategy を timestamp に変更する

> **難易度**: ★★☆ 応用  
> **目的**: `strategy='timestamp'` の Snapshot を書けることを確認する

---

## 問題

注文データに対して timestamp strategy を使った Snapshot を作成せよ。

### 要件

1. ファイル: `hands-on/dbt/dbt_learn/snapshots/snap_orders_ts.sql`
2. ソース: `{{ ref('stg_orders') }}`
3. `unique_key`: `order_id`
4. `strategy`: `timestamp`
5. `updated_at`: `order_date`（実務では更新日時カラムを使うが、学習用に order_date で代用）
6. `target_schema`: `SNAPSHOTS`
7. `target_database`: `DBT_LEARN`

### ヒント

- `strategy='timestamp'` では `check_cols` の代わりに `updated_at` を指定する
- `updated_at` で指定したカラムの値が前回より新しければ、変更ありと判断される

---

## 検証手順

```bash
# 1. compile で SQL を確認
dbt compile --select snap_orders_ts --project-dir hands-on/dbt/dbt_learn

# 2. Snapshot を実行
dbt snapshot --select snap_orders_ts --project-dir hands-on/dbt/dbt_learn
```

### 期待する結果

```
Completed successfully

Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1
```

```sql
-- テーブルが作られていることを確認
SELECT COUNT(*) FROM DBT_LEARN.SNAPSHOTS.SNAP_ORDERS_TS;
```

---

## 発展: check vs timestamp

- `check` strategy: 指定カラムを毎回全行比較 → 正確だが負荷が高い
- `timestamp` strategy: updated_at カラムの日時だけ見る → 軽量だが、updated_at が正しく更新されることが前提

> **問い**: どんなケースでは `check` を使わざるを得ないか？  
> → ソーステーブルに `updated_at` 相当のカラムがない場合。

---

模範解答 → [answers/snap_orders_ts.sql](answers/snap_orders_ts.sql)
