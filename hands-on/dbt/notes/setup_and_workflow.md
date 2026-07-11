# dbt セットアップ & 実行ワークフロー

> 作成日: 2026-05-22  
> 対象プロジェクト: jaffle-shop（dbt公式サンプル）  
> 使用アダプタ: dbt-duckdb（ローカル検証用）/ dbt-snowflake（本番想定）

---

## 環境構成

| 項目 | 内容 |
|---|---|
| パッケージマネージャ | uv |
| 仮想環境 | uv が自動生成する `.venv` |
| dbt アダプタ | dbt-duckdb 1.10.1 以上 / dbt-snowflake 1.11.5 以上 |
| DB（ローカル） | DuckDB（ファイル: `jaffle_shop.duckdb`） |
| dbt プロファイル | `~/.dbt/profiles.yml` |

---

## Step 1: uv でプロジェクトを初期化する

```zsh
# 作業ディレクトリに移動
cd ~/study/Snowflake/dbt

# uv でプロジェクト作成（.venv も自動生成される）
uv init dbt-tutorial

cd dbt-tutorial
```

`uv init` を実行すると以下が生成される:

```
dbt-tutorial/
├── .python-version   # 使用する Python バージョン
├── .venv/            # 仮想環境（自動生成）
├── pyproject.toml    # 依存関係の管理ファイル
├── uv.lock           # ロックファイル
└── hello.py          # サンプルファイル（不要なら削除可）
```

---

## Step 2: dbt アダプタをインストールする

```zsh
# DuckDB アダプタ（ローカル検証用）
uv add dbt-duckdb

# Snowflake アダプタ（本番・クラウド接続用）
uv add dbt-snowflake
```

インストール後、`pyproject.toml` の `dependencies` に追記される:

```toml
[project]
name = "dbt-tutorial"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = [
    "dbt-duckdb>=1.10.1",
    "dbt-snowflake>=1.11.5",
]
```

---

## Step 3: 仮想環境を有効化する

```zsh
# dbt-tutorial ディレクトリ直下から実行
source .venv/bin/activate

# サブディレクトリ（jaffle-shop 内など）から実行する場合
source ../.venv/bin/activate

# dbt が使えるか確認
dbt --version
```

> **注意**: ターミナルセッションを新たに開くたびに `source` での有効化が必要。  
> プロンプトに `(dbt-tutorial)` が表示されていれば有効化済み。

---

## Step 4: サンプルプロジェクト（jaffle-shop）を取得する

```zsh
# dbt-tutorial ディレクトリ内でクローン
git clone https://github.com/dbt-labs/jaffle-shop.git

cd jaffle-shop
```

クローン後のディレクトリ構成:

```
jaffle-shop/
├── models/           # SQLモデル（staging/ と marts/ に分かれる）
├── seeds/            # 初期データ用CSVファイル
├── macros/           # Jinja マクロ
├── analyses/         # 分析用SQL（モデルとして管理しないもの）
├── data-tests/       # データテスト定義
├── dbt_project.yml   # プロジェクト設定ファイル
└── package-lock.yml  # dbt パッケージのロックファイル
```

### dbt_project.yml の要点

```yaml
profile: jaffle_shop          # profiles.yml と対応するプロファイル名

seeds:
  jaffle_shop:
    +schema: raw              # seed データは raw スキーマに入る
    jaffle-data:
      +enabled: "{{ var('load_source_data', false) }}"  # デフォルトは無効

models:
  jaffle_shop:
    staging:
      +materialized: view     # staging 層はビューとして作成
    marts:
      +materialized: table    # marts 層はテーブルとして作成
```

---

## Step 5: profiles.yml を設定する

dbt の接続設定は `~/.dbt/profiles.yml` に記述する（プロジェクトとは別管理）。

```zsh
mkdir ~/.dbt
touch ~/.dbt/profiles.yml
vim ~/.dbt/profiles.yml
```

### DuckDB 接続の設定例（今回の設定）

```yaml
jaffle_shop:
  outputs:
    dev:
      type: duckdb
      path: jaffle_shop.duckdb   # DBファイルの保存先（実行ディレクトリからの相対パス）
      threads: 1
  target: dev
```

> `path` は `jaffle-shop/` ディレクトリ内から `dbt run` を実行すると、  
> そのディレクトリ直下に `jaffle_shop.duckdb` が生成される。

---

## Step 6: dbt コマンドの実行フロー

以下のコマンドは `jaffle-shop/` ディレクトリ内で実行する。

### 6-1. 接続確認

```zsh
dbt debug
```

- `profiles.yml` の設定が正しいか、DB に接続できるかを検証する
- `All checks passed!` が出れば成功
- **失敗した場合**: venv が有効化されているか、profiles.yml のプロファイル名が `dbt_project.yml` の `profile:` と一致しているか確認

### 6-2. 依存パッケージのインストール

```zsh
dbt deps
```

- `packages.yml`（または `dbt_project.yml` 内の `packages:`）に記載されたパッケージをインストール
- 今回のプロジェクトで使用しているパッケージ:
  - `dbt-labs/dbt_utils` 1.3.3
  - `godatadriven/dbt_date` 0.17.1
  - `dbt-labs/dbt-audit-helper`（GitHub 直接指定）

### 6-3. シードデータのロード

```zsh
# 通常実行（load_source_data が false のため jaffle-data は無効）
dbt seed

# jaffle-data を含めて強制再ロード
dbt seed --full-refresh --vars '{"load_source_data": true}'
```

- `seeds/` 配下の CSV ファイルを DB に取り込む
- `--full-refresh`: 既存テーブルを DROP して再作成
- `--vars '{"load_source_data": true}'`: `dbt_project.yml` の `vars` を上書き（jaffle-data を有効化）

### 6-4. モデルの実行

```zsh
dbt run
```

- `models/` 配下の SQL ファイルを実行し、ビュー・テーブルを作成する
- 実行順序は依存関係（`ref()` 関数）に基づいて自動解決される

---

## コマンドまとめ

| コマンド | 目的 | 実行タイミング |
|---|---|---|
| `uv init <name>` | プロジェクト＆仮想環境の作成 | 最初の1回 |
| `uv add <pkg>` | パッケージのインストール | アダプタ追加時 |
| `source .venv/bin/activate` | 仮想環境の有効化 | セッション開始時 |
| `dbt debug` | 接続・設定の検証 | profiles.yml 変更時 |
| `dbt deps` | dbt パッケージのインストール | packages.yml 変更時 |
| `dbt seed` | CSV → DB へのデータロード | 初回 or データ変更時 |
| `dbt run` | SQLモデルの実行 | モデル変更・動作確認時 |

---

## トラブルシューティング

### `dbt: command not found` が出る場合

仮想環境が有効化されていない。`source .venv/bin/activate`（または `source ../.venv/bin/activate`）を実行する。

### `dbt debug` で接続エラーが出る場合

1. `~/.dbt/profiles.yml` のプロファイル名（`jaffle_shop:` の部分）と `dbt_project.yml` の `profile:` が一致しているか確認
2. `dbt_project.yml` が存在するディレクトリで実行しているか確認

### seed で `jaffle-data` が取り込まれない場合

`--vars '{"load_source_data": true}'` オプションが必要。`dbt_project.yml` で `load_source_data` のデフォルトが `false` になっているため。
