# Lesson 9 — 演習 2: セレクタを駆使してバッチ戦略を設計する

> **難易度**: ★★★ 発展  
> **目的**: 実運用を想定したバッチ実行戦略を tags + セレクタで設計する

---

## 問題

以下のバッチ実行要件を満たすよう、tags とセレクタコマンドを設計せよ。

### シナリオ

あなたのチームでは以下の運用要件がある：

| バッチ | 頻度 | 対象 |
|--------|------|------|
| 日次バッチ（深夜） | 毎日 03:00 | 全 staging + marts 全体 |
| 時間バッチ | 毎時 | `agg_daily_orders` のみ（リアルタイムに近い集計） |
| 週次バッチ | 毎週日曜 | dim_customers（重い再計算） |
| アドホック修正 | 手動 | 指定モデルとその下流のみ |

### 要件

1. 各モデルに適切な `tags` を設計して付与する方針を記述する
2. 各バッチに対応する `dbt run` コマンドを記述する
3. 「stg_customers を修正した」場合のアドホック再実行コマンドを記述する
4. 週次バッチの前に full-refresh するコマンドを記述する

### 提出形式

以下のテンプレートを埋める（`answers/batch_strategy.md` として提出）：

```markdown
## Tags 設計

| モデル | tags |
|--------|------|
| stg_* | ??? |
| fct_orders | ??? |
| dim_customers | ??? |
| agg_daily_orders | ??? |

## バッチコマンド

### 日次バッチ
\```bash
dbt run ???
\```

### 時間バッチ
\```bash
dbt run ???
\```

### 週次バッチ
\```bash
dbt run ???
\```

### アドホック修正（stg_customers 変更時）
\```bash
dbt run ???
\```
```

---

## ヒント

- 1つのモデルに複数 tags を付与できる: `tags: ['daily', 'critical']`
- `--full-refresh` は incremental モデルを最初から再作成する
- アドホック修正では `+` 演算子で下流を含める
- `dbt list` で事前に対象モデルを確認する習慣をつける

---

## 検証

実際にコマンドを実行して、意図したモデルだけが対象になるか `dbt list` で確認する：

```bash
# 例: 日次バッチの対象確認
dbt list --select tag:daily --project-dir dbt/dbt_learn
```

---

模範解答 → [answers/batch_strategy.md](answers/batch_strategy.md)
