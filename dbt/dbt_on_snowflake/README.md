# dbt ハンズオン学習コース — Snowflake 完結版

> dbt を一切知らない人が、Snowflake Workspace 上で **手を動かしながら** 基礎から本番運用まで学べるカリキュラム。

---

## 特徴

- **全て Snowflake 上で完結** — ローカル環境のセットアップ不要
- **ハンズオン形式** — 各 Step で「やること」が明確。実行 → 確認のサイクル
- **実験で学ぶ** — わざとエラーを起こし、挙動を体感する
- **確認クイズ付き** — 各レッスン末尾で理解度をセルフチェック

---

## 前提条件

- Snowflake アカウント（SYSADMIN ロール推奨）
- SQL の基本知識（SELECT / JOIN / GROUP BY が書ける）
- Snowsight にログインできる

---

## カリキュラム構成

| # | レッスン | 所要時間 | 内容 |
|---|---------|---------|------|
| 1 | [dbt を体感する](lesson_01/lesson_01_what_is_dbt.md) | 20分 | SQL でデータ変換の問題を体感し、dbt の必要性を理解 |
| 2 | [プロジェクトを作る](lesson_02/lesson_02_setup.md) | 15分 | dbt_project.yml / profiles.yml を作成し parse で検証 |
| 3 | [最初のモデルを実行する](lesson_03/lesson_03_first_models.md) | 25分 | staging モデル → compile → run → SQL で結果確認 |
| 4 | [Marts 層を充実させる](lesson_04/lesson_04_marts_and_materialization.md) | 30分 | dim/fct/agg + view vs table の実験 + incremental |
| 5 | [テストでデータ品質を守る](lesson_05/lesson_05_tests_and_docs.md) | 25分 | テスト追加 → 故意に壊す → FAIL 体験 → build の挙動確認 |
| 6 | [Jinja とマクロ](lesson_06/lesson_06_jinja_and_macros.md) | 30分 | var/if/for を compile で確認 + マクロ自作 |
| 7 | [デプロイして本番運用する](lesson_07/lesson_07_deploy_and_schedule.md) | 20分 | CREATE/EXECUTE DBT PROJECT + TASK スケジューリング |

**合計**: 約 2.5 時間

---

## クイックスタート

### 1. データベースを作成する（SQL Worksheet で1回だけ実行）

```sql
CREATE DATABASE IF NOT EXISTS DBT_LEARN;
CREATE SCHEMA IF NOT EXISTS DBT_LEARN.ANALYTICS;
```

### 2. Workspace でプロジェクトを確認

```bash
dbt parse --project-dir dbt/dbt_learn
```

### 3. Lesson 1 から順に進める

→ [Lesson 1: dbt を体感する](lesson_01/lesson_01_what_is_dbt.md) から開始！

---

## プロジェクト構成

`dbt_learn/` に実習用プロジェクトが含まれている：

```
dbt_learn/
├── dbt_project.yml          # プロジェクト設定
├── profiles.yml             # Snowflake 接続設定
├── models/
│   ├── sources.yml          # ソーステーブル定義
│   ├── staging/
│   │   ├── staging.yml      # テスト・ドキュメント定義
│   │   ├── stg_orders.sql
│   │   ├── stg_customers.sql
│   │   ├── stg_line_items.sql
│   │   └── stg_nations.sql
│   └── marts/
│       ├── marts.yml        # テスト・ドキュメント定義
│       ├── fct_orders.sql
│       ├── fct_line_items.sql   (incremental)
│       ├── dim_customers.sql
│       └── agg_daily_orders.sql
├── tests/
│   └── assert_total_price_positive.sql
└── macros/
    └── limit_in_dev.sql
```

---

## ソースデータ

`SNOWFLAKE_SAMPLE_DATA.TPCH_SF1` を使用（追加のデータ準備不要）：

| テーブル | 内容 | 行数 |
|---------|------|------|
| ORDERS | 注文ヘッダー | 150万 |
| CUSTOMER | 顧客 | 15万 |
| LINEITEM | 注文明細 | 600万 |
| NATION | 国 | 25 |
| REGION | 地域 | 5 |

---

## 学習のコツ

1. **必ず手を動かす** — 読むだけでは身につかない。各 Step のコマンドを実行する
2. **エラーを恐れない** — レッスン内で意図的にエラーを起こす実験がある。エラーメッセージを読む力が身につく
3. **compile を多用する** — `dbt compile` で Jinja が何に展開されるか確認する癖をつける
4. **SQL Worksheet で検証** — dbt が作ったオブジェクトを SQL で直接確認する
5. **チェックポイントで立ち止まる** — 期待する結果と実際が異なる場合は先に進まず原因を調べる
