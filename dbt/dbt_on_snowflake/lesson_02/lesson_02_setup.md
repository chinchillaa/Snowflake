# Lesson 2: Snowflake 上で dbt プロジェクトを作る

> **所要時間**: 15分  
> **形式**: ファイルを1つずつ作成し、各ステップで検証する

---

## ゴール

このレッスンを終えると：
- dbt プロジェクトの最小構成が分かる
- `profiles.yml` を正しく書ける
- `dbt parse` でプロジェクトの構文検証ができる

---

## Step 1: 学習用データベースを確認する

> Lesson 1 で既に作成済みのはず。未作成なら SQL Worksheet で実行：

```sql
CREATE DATABASE IF NOT EXISTS DBT_LEARN;
CREATE SCHEMA IF NOT EXISTS DBT_LEARN.ANALYTICS;
```

**検証**:

```sql
SHOW SCHEMAS IN DATABASE DBT_LEARN;
```

> `ANALYTICS` と `RAW`（任意）が表示されれば OK。

---

## Step 2: プロジェクト構造を理解する

dbt プロジェクトの最小構成は **たった2ファイル**：

```
dbt_learn/
├── dbt_project.yml    ← プロジェクト設定
└── profiles.yml       ← 接続情報
```

モデルを追加すると：

```
dbt_learn/
├── dbt_project.yml
├── profiles.yml
└── models/
    ├── sources.yml       ← ソーステーブル定義
    ├── staging/          ← 下ごしらえ層
    └── marts/            ← ビジネスロジック層
```

---

## Step 3: dbt_project.yml を作成する

> **やること**: Workspace 内で `dbt/dbt_learn/dbt_project.yml` を開き、以下の内容になっていることを確認する。
> 無ければ新規作成する。

```yaml
name: 'dbt_learn'
version: '1.0.0'

profile: 'dbt_learn'

model-paths: ["models"]
test-paths: ["tests"]
macro-paths: ["macros"]
seed-paths: ["seeds"]

clean-targets:
  - "target"
  - "dbt_packages"

models:
  dbt_learn:
    staging:
      +materialized: view
    marts:
      +materialized: table
```

### 各行の意味（読みながら確認）

| 行 | やっていること |
|----|--------------|
| `name: 'dbt_learn'` | プロジェクト名。フォルダ名と揃えると分かりやすい |
| `profile: 'dbt_learn'` | profiles.yml のどのプロファイルを使うか |
| `model-paths: ["models"]` | モデル SQL を探すディレクトリ |
| `staging: +materialized: view` | staging 配下はデフォルトで VIEW として作成 |
| `marts: +materialized: table` | marts 配下はデフォルトで TABLE として作成 |

---

## Step 4: profiles.yml を作成する

> **やること**: `dbt/dbt_learn/profiles.yml` を開き確認する。

```yaml
dbt_learn:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: ""
      user: ""
      role: SYSADMIN
      database: DBT_LEARN
      warehouse: COMPUTE_WH
      schema: ANALYTICS
      threads: 4
```

### Snowflake Workspace 固有のポイント

| 項目 | なぜこの値？ |
|------|-------------|
| `account: ""` | Workspace が自動でセッション情報を使うので空でOK |
| `user: ""` | 同上 |
| `role: SYSADMIN` | あなたのロール名に合わせる |
| `database: DBT_LEARN` | Step 1 で作ったDB |
| `warehouse: COMPUTE_WH` | あなたのウェアハウス名に合わせる |
| `schema: ANALYTICS` | モデルが作られるスキーマ |

### やってはいけないこと（覚えておく）

```yaml
# NG例 — Workspace では以下を書くとエラーになる：
password: "secret"           # ← 禁止
authenticator: externalbrowser  # ← 禁止
account: "{{ env_var('SF_ACCOUNT') }}"  # ← 禁止
```

---

## Step 5: 最初の検証 — dbt parse

> **やること**: Workspace ターミナルで以下を実行する。

```bash
dbt parse --project-dir dbt/dbt_learn
```

### 期待する結果

```
Performance info: ...
```

エラーが出なければ成功。モデルファイルが既にあれば `Found N models` と表示される。

### エラーが出た場合

| エラーメッセージ | 対処 |
|----------------|------|
| `Could not find profile named 'dbt_learn'` | profiles.yml のプロファイル名が dbt_project.yml の `profile:` と一致していない |
| `Unsupported fields found: password` | profiles.yml から `password` を削除 |
| `dbt_project.yml not found` | --project-dir のパスが正しいか確認 |

---

## Step 6: ソース定義を追加する

> **やること**: `dbt/dbt_learn/models/sources.yml` を開き確認する。

```yaml
version: 2

sources:
  - name: tpch
    database: SNOWFLAKE_SAMPLE_DATA
    schema: TPCH_SF1
    description: "TPC-H ベンチマークデータ（SF=1）"
    tables:
      - name: orders
        description: "注文ヘッダー"
      - name: customer
        description: "顧客マスター"
      - name: lineitem
        description: "注文明細"
      - name: nation
        description: "国マスター"
      - name: region
        description: "地域マスター"
```

### これが何をしているか

`source('tpch', 'orders')` と書くと → `SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS` に自動展開される。

---

## Step 7: 再度 parse して確認

```bash
dbt parse --project-dir dbt/dbt_learn
```

エラーが出なければ、プロジェクトの骨格は完成。

---

## Step 8: ここまでの状態を確認

> **やること**: 以下のコマンドでファイル一覧を確認する。

```bash
ls -R dbt/dbt_learn
```

最低限、以下が揃っていれば OK：

```
dbt_learn/
├── dbt_project.yml     ✓
├── profiles.yml        ✓
└── models/
    └── sources.yml     ✓
```

---

## 確認クイズ

1. `dbt_project.yml` の `profile:` は何と対応している？
2. Snowflake Workspace の profiles.yml で `account` を空にしていい理由は？
3. `dbt parse` は何を検証している？

<details>
<summary>答えを見る</summary>

1. `profiles.yml` の最上位キー名と対応する（今回は `dbt_learn`）
2. Workspace が Snowflake セッション情報を自動注入するため
3. YAML/SQL の構文エラー、参照先の存在チェック（コンパイル前の検証）

</details>

---

## このレッスンで作ったもの

- [x] `DBT_LEARN` データベース + `ANALYTICS` スキーマ
- [x] `dbt_project.yml`（プロジェクト設定）
- [x] `profiles.yml`（Snowflake 接続）
- [x] `models/sources.yml`（ソーステーブル定義）
- [x] `dbt parse` の成功を確認

---

## 演習問題

→ [演習: profiles.yml のトラブルシューティング](exercises/lesson_02/exercise_01.md)

---

## 次のレッスン

→ [Lesson 3: 最初のモデルを作って実行する](lesson_03_first_models.md)
