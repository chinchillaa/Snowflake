# 演習 2 模範解答: バッチ戦略設計

## Tags 設計

| モデル | tags |
|--------|------|
| stg_* (全 staging) | `["staging", "daily"]` |
| fct_orders | `["marts", "daily"]` |
| dim_customers | `["marts", "daily", "weekly_heavy"]` |
| agg_daily_orders | `["marts", "daily", "hourly", "reporting"]` |

## バッチコマンド

### 日次バッチ（毎日 03:00）

```bash
dbt run --select tag:daily --project-dir dbt/dbt_learn
```

### 時間バッチ（毎時）

```bash
dbt run --select tag:hourly --project-dir dbt/dbt_learn
```

### 週次バッチ（毎週日曜 — full-refresh 付き）

```bash
dbt run --select tag:weekly_heavy --full-refresh --project-dir dbt/dbt_learn
```

### アドホック修正（stg_customers 変更時）

```bash
# まず影響範囲を確認
dbt list --select stg_customers+ --project-dir dbt/dbt_learn

# 確認後、stg_customers とその下流を全て再実行
dbt run --select stg_customers+ --project-dir dbt/dbt_learn
```

## 解説

- `daily` タグで全モデルを網羅し、日次バッチの1コマンドで全実行
- `hourly` はリアルタイム性が必要な集計のみに付与
- `weekly_heavy` は計算コストが高いモデルに付与し、`--full-refresh` と組み合わせる
- アドホック修正は `+` 演算子で下流を自動的に含め、変更の波及を確実にカバー
- `dbt list` を事前に実行して対象を目視確認する習慣が重要
