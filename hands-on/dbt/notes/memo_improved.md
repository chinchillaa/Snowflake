# dbt（data build tool）入門ガイド

> **対象プロジェクト**: `dbt-tutorial/jaffle-shop`
> **対象読者**: SQL は書けるが dbt は初めての方

---

## 目次

1. [dbt とは何か](#1-dbt-とは何か)
2. [開発環境のセットアップ](#2-開発環境のセットアップ)
3. [jaffle-shop を動かす](#3-jaffle-shop-を動かす)
4. [dbt モデルの仕組み](#4-dbt-モデルの仕組み)
5. [プロジェクト構造のベストプラクティス](#5-プロジェクト構造のベストプラクティス)

---

## 1. dbt とは何か

### 1.1 概要

dbt（data build tool）は、データウェアハウス内でのデータ変換を管理するためのオープンソースツールです。データアナリストやアナリティクスエンジニアが、SQL を書くだけでデータパイプラインを構築・テスト・ドキュメント化できるように設計されています。

従来、データ変換処理には Python や Java などのプログラミング言語で複雑なスクリプトを書く必要がありました。データの抽出・変換・ロードという一連の処理を、それぞれ異なるツールやフレームワークで管理しなければならず、データエンジニアリング分野の専門知識が求められていました。

dbt はこの状況を大きく変えました。SQL さえ書ければデータ変換パイプラインを構築できるため、データアナリストが、データエンジニアリングの専門知識がなくてもデータ変換作業を担えるようになりました。

---

### 1.2 主要機能

#### SQL によるデータ変換の定義

dbt では、SELECT 文を書くだけでデータ変換処理を定義できます。従来のデータパイプラインでは、CREATE TABLE でテーブルを作成し、INSERT 文や MERGE 文でデータを投入するという手続き的な SQL を書く必要がありました。

dbt はこの手間を解消し、分析者は「どんなデータが欲しいか」を SELECT 文で記述するだけで済みます。テーブルやビューの作成に必要な DDL（Data Definition Language：テーブル定義）や DML（Data Manipulation Language：データ操作）は dbt が自動生成してくれるため、ビジネスロジックの記述に集中できます。

#### 依存関係の自動解決

dbt では、モデル間の依存関係を `ref()` 関数で定義します（`ref()` 関数については [4.3 節](#43-ref-関数と-source-関数) で詳しく解説します）。

例えば、売上集計モデルが顧客マスタモデルを参照している場合、`ref('customers')` と書くだけで依存関係が記録されます。dbt はこの情報をもとに **DAG（Directed Acyclic Graph：有向非循環グラフ）** を構築し、正しい実行順序を自動的に決定します。

> **DAG とは？**
> 「どのモデルをどの順番で実行するか」を表したグラフです。矢印が一方向にしか向かない（循環しない）ため、実行順序が一意に決まります。dbt はこのグラフを自動生成し、依存するモデルが必ず先に実行されることを保証します。

モデルの数が増えても、手動で実行順序を管理する必要はありません。変更があったモデルとその下流（そのモデルの結果を使うモデル）だけを選択的に実行することも可能です。

#### テスト機能

dbt では、データ品質を検証するテストを YAML ファイルで宣言的に定義できます。

- 「このカラムは NULL にならない」
- 「このカラムの値はユニークである」
- 「このカラムの値は別テーブルのカラムに存在する」

といったテストを、SQL を書かずに設定ファイルに記述するだけで実施できます。`dbt test` コマンド一つでそのテストを一括実行でき、データパイプラインの品質を継続的に担保できます。より複雑な検証が必要な場合は、SQL でカスタムテストを書くこともできます。

#### ドキュメント自動生成

dbt では、モデルやカラムの説明を YAML ファイルに記述しておくと、Web サイト形式のドキュメントを自動生成できます。生成されたドキュメントには **データリネージ**（Data Lineage：データがどこから来て、どのように変換・加工されてきたかの流れ）がグラフとして可視化されるため、「このデータはどこから来ているのか」が一目でわかります。ドキュメントはコードと同じリポジトリで管理されるため、モデルの変更に合わせて常に最新の状態を保てます。

#### バージョン管理との親和性

dbt のモデルは SQL ファイルと YAML ファイルで構成されるため、Git によるバージョン管理と非常に相性が良いです。プルリクエストを使ったコードレビュー、ブランチを使った並行開発、CI による自動テストなど、ソフトウェアエンジニアリングで培われたベストプラクティスをデータ変換の世界にそのまま持ち込めます。「誰が、いつ、なぜこのロジックを変更したのか」がコミット履歴として残るため、変更の追跡や障害発生時の原因調査も容易になります。

---

### 1.3 データパイプライン全体の中での位置づけ

一般的なデータパイプラインは、以下のような流れで構成されます。

1. **データソース**：業務システム、SaaS アプリケーション、IoT デバイスなど、様々なシステムからデータが生成されます
2. **抽出・ロード（EL）**：Fivetran、Airbyte、Stitch などのツールを使って、データソースからデータウェアハウスにデータを取り込みます
3. **変換（T）**：取り込まれたデータを、分析に適した形に変換します。**ここが dbt の担当領域**です
4. **分析・可視化**：Tableau、Looker などの BI ツール（Business Intelligence ツール：データを集計・グラフ化して分析するためのツール）を使って、変換されたデータを可視化・分析します

dbt は「変換（T）」の部分に特化しており、データの抽出やロードには関与しません。各ツールが得意な領域を担当し、それらを組み合わせてデータ基盤を構築するアーキテクチャは **モジュラー・データスタック** と呼ばれ、現代のデータ基盤における標準的な設計手法となっています。

---

### 1.4 ELT と ETL の違い

データパイプラインの構築方法として、ETL と ELT という２つのアプローチがあります。

#### ETL（Extract → Transform → Load）

「抽出（Extract）→ 変換（Transform）→ ロード（Load）」の略です。データソースからデータを抽出した後、**外部の処理サーバー**でデータを変換し、最終的にデータウェアハウスにロードするアプローチです。

変換処理のために Python や Java のプログラムを書き、その実行環境を維持・管理しなければなりません。データ量が増えると、サーバーのスケーリングも必要になります。

#### ELT（Extract → Load → Transform）

「抽出（Extract）→ ロード（Load）→ 変換（Transform）」の略です。データソースから抽出したデータを、まずそのままデータウェアハウスにロードし、その後**データウェアハウスの中で SQL を使って変換**するアプローチです。

近年、BigQuery、Snowflake、Redshift などのクラウドデータウェアハウスの性能が劇的に向上し、大規模データに対しても SQL クエリを高速に実行できるようになったため、ELT アプローチが主流となっています。

#### dbt は ELT の「T」を担う

dbt は ELT における「T（Transform）」の部分を担当するツールです。データウェアハウスにロードされた生データを、分析に適した形に変換する役割に特化しています。

---

### 1.5 dbt Core と dbt Cloud の違い

dbt には、**dbt Core** と **dbt Cloud** の２つのバリエーションがあります。

#### dbt Core

オープンソース版です。Apache 2.0 ライセンスで公開されており、誰でも無料で利用できます。ターミナルからコマンドを実行して操作する CLI ツールで、自分の環境に合わせて自由にカスタマイズできます。一方、ジョブのスケジューリングや CI/CD 連携は自分で管理する必要があります。

#### dbt Cloud

dbt Labs が提供する SaaS（Software as a Service）版です。dbt Core の機能に加えて、ブラウザ上で SQL の編集や dbt の実行ができる Web IDE、ジョブのスケジューリング機能、プルリクエスト作成時に自動テストを実行する CI/CD 連携、GUI での実行結果管理画面などを備えています。チームでの運用を想定した機能が充実しています。

#### 本書では dbt Core を使用

本書では dbt Core を使って学習を進めていきます。無料で始められ、dbt の本質的な機能を体験できるためです。dbt Core で学んだ内容は dbt Cloud にもそのまま活用できます。

> **Column：dbt Fusion について**
>
> 2025 年、dbt Labs は **dbt Fusion** と称される新しいランタイムエンジンを発表しました。Rust で書き直された次世代のコアエンジンで、従来の dbt Core と比べて大幅な高速化が期待されています。dbt Cloud だけでなくローカル CLI でも利用可能とされており、段階的にリリースが予定されています。
>
> 本書は dbt Core をベースにしていますが、モデル・テスト・ドキュメント・マテリアライゼーション（後述）などの基本概念は dbt Fusion でもそのまま通用します。まずは dbt Core でしっかり基礎を身につけましょう。

---

## 2. 開発環境のセットアップ

この章では、dbt を使い始めるための開発環境を整えていきます。本書では、サーバー不要で手軽に始められる DuckDB をデータプラットフォームとして使用し、Python のパッケージ管理ツールである uv を使って環境を構築します。

---

### 2.1 DuckDB とは

DuckDB は、分析用途に特化した軽量なデータベース管理システムです。

#### なぜ DuckDB を使うのか

dbt を学習する際、本来のデータウェアハウス（BigQuery、Snowflake、Redshift など）を用意するのはハードルが高いかもしれません。クラウドサービスのアカウント作成、課金設定、ネットワーク設定など、dbt の学習とは直接関係のない事前準備が必要になります。

DuckDB を使えば、こうした事前準備を一切省略できます。ファイル一つでデータベースが起動できるため、インストールしたその瞬間から dbt を試すことができます。

#### DuckDB の特徴

- **インプロセス（組み込み型）**：SQLite のように外部サーバーや依存関係なしで動作します。データベースは単一ファイル（例：`jaffle_shop.duckdb`）として永続化されるため、ファイルをコピーするだけで別環境に移動できます。
- **高い分析性能**：列指向のベクトル化エンジンを採用しています。列指向ストレージとは、データを行単位ではなく列単位で格納する方式です。分析処理では特定の列だけを集計することが多いため、必要な列のデータだけを読み込むことができ、処理速度が大幅に向上します。
- **豊富な SQL 機能**：複雑なクエリ、ウィンドウ関数、豊富な組み込み関数など、分析に必要な機能が一通り揃っています。CSV、Parquet、JSON などのファイル形式を直接クエリできます。
- **高いポータビリティ**：Linux、macOS、Windows のあらゆる環境で利用できます。MIT ライセンスのオープンソースで、完全無料です。

DuckDB のインストールは、次のステップで dbt と一緒に行うため、ここでは別個にインストールする必要はありません。

---

### 2.2 uv とは

uv は、Python のパッケージ管理ツールです。Rust 製の高速なツールで、従来の pip や venv に比べて非常に高速に動作します。

#### なぜ uv を使うのか

dbt Core は Python で書かれたツールです。Python のツールを使う際には、パッケージの依存関係管理と仮想環境の管理が重要になります。

**仮想環境**とは、プロジェクトごとに独立した Python 実行環境を作る仕組みです。仮想環境を使わずにグローバルにパッケージをインストールしてしまうと、異なるプロジェクトで必要なパッケージのバージョンが衝突するという問題が起こりえます。仮想環境を使えば、プロジェクト A では dbt 1.8 を、プロジェクト B では dbt 1.11 を、というように異なるバージョンを共存させられます。

従来は pip でパッケージをインストールし、venv で仮想環境を作るという２つのツールを組み合わせて使う必要がありました。uv はこれらの機能を統合し、一つのツールで仮想環境の作成からパッケージ管理まで全てシンプルにできるようにしたものです。

#### uv の特徴

- **圧倒的な速度**：pip の 10〜100 倍高速にパッケージをインストールできます。大量の依存パッケージを持つ dbt のインストールでも、待ち時間がほとんどありません。
- **自動的な仮想環境管理**：`uv init` でプロジェクトを作成すると仮想環境が自動的に準備されるため、venv コマンドを手動で実行する必要がありません。
- **厳密な依存関係管理**：依存関係は `pyproject.toml` と `uv.lock` で管理され、チームメンバー全員が同じバージョンのパッケージを使えることが保証されます。
- **Python バージョン管理**：uv 自身が Python のインストール・切り替え機能も備えているため、pyenv などの別ツールが不要です。

---

### 2.3 インストール手順

開発環境は Mac を前提としていますが、Linux や WSL（Windows Subsystem for Linux）でも同様の手順で進められます。

#### uv のインストール

まず、uv をインストールします。以下のコマンドを実行してください。

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

> **Note**：Homebrew を使っている場合は以下でもインストールできます。
>
> ```bash
> brew install uv
> ```

インストール後、ターミナルを再起動するか、`source ~/.zshrc`（bash の場合は `source ~/.bashrc`）を実行して、uv コマンドが使えることを確認しましょう。

```bash
uv --version
```

バージョン番号が表示されれば、インストール成功です。

#### プロジェクトの作成

チュートリアル用のプロジェクトを uv で作成します。任意のディレクトリで以下のコマンドを実行してください。

```bash
uv init dbt-tutorial   # プロジェクトディレクトリの作成
cd dbt-tutorial
```

`uv init` コマンドを実行すると、プロジェクトディレクトリが作成されます。主要なファイルは `pyproject.toml` で、ここにプロジェクトの設定と依存パッケージの情報が管理されます。`uv add` でパッケージをインストールすると、このファイルに依存関係が自動的に追記されます。

#### dbt-duckdb のインストール

プロジェクトが作成できたら、いよいよ dbt をインストールします。dbt からデータプラットフォームに接続するためには、接続先に対応した**アダプター**が必要です。アダプターとは、dbt と各データプラットフォームの間の通信を仲介するパッケージのことです。

今回は DuckDB を使用するので、DuckDB 用アダプターである `dbt-duckdb` をインストールします。

```bash
# dbt-duckdb をインストールすると dbt-core 本体も一緒にインストールされる
uv add dbt-duckdb
```

このコマンドを実行すると、`dbt-duckdb` パッケージとその依存関係（dbt-core 本体を含む）が自動的にインストールされます。また、このタイミングで `.venv`（仮想環境のディレクトリ）も自動的に作成されます。

インストール完了後、仮想環境を有効化します。

```bash
source .venv/bin/activate
# 成功するとプロンプトが (dbt-tutorial) に変わる
```

仮想環境が有効化されると、ターミナルのプロンプトに `(dbt-tutorial)` と表示されます。この状態で dbt コマンドが使えるようになります。

> **Note**：仮想環境を有効化する代わりに、`uv run dbt <subcommand>` という形式でコマンドを実行することもできます（例：`uv run dbt debug`）。仮想環境の有効化を忘れがちな場合や、スクリプトから実行する場合はこの方法が便利です。本書では `source .venv/bin/activate` での有効化を前提として解説しますが、どちらの方法でも同じ結果が得られます。

dbt のバージョンを確認してみましょう。

```bash
$ dbt --version
Core:
  - installed: 1.11.0
Plugins:
  - duckdb: 1.10.1
```

dbt Core と DuckDB アダプターのバージョンが正しく表示されれば、インストールは完了です。

---

## 3. jaffle-shop を動かす

### 3.1 jaffle-shop とは

jaffle-shop は、dbt Labs（dbt の開発元）が公式に公開しているサンプルプロジェクトです。架空の EC サイトのデータを使って、dbt のデータ変換・テスト・ドキュメント生成などの主要機能を一通り体験できるようになっています。

---

### 3.2 リポジトリの clone

jaffle-shop のリポジトリを GitHub から clone します。先ほど作成した `dbt-tutorial` ディレクトリ内で、以下のコマンドを実行してください。

```bash
cd dbt-tutorial
git clone https://github.com/dbt-labs/jaffle-shop.git
cd jaffle-shop
```

clone が完了すると、`jaffle-shop` ディレクトリ内に dbt プロジェクトの構成ファイルが展開されます。

---

### 3.3 プロファイルの設定

dbt を実行するには、データプラットフォームへの接続情報を設定する必要があります。この接続情報をまとめたものを**プロファイル**と呼びます。

> **プロファイルとは？**
> dbt がどのデータベースにどのように接続するかを定義した設定ファイルです。開発環境・本番環境など、複数の接続先を一つのファイルで管理できます。

#### プロファイル名の確認

`dbt_project.yml` を開き、`profile` の値が `jaffle_shop` になっていることを確認します。

```yaml
# dbt_project.yml（抜粋）
profile: jaffle_shop  # この名前と profiles.yml のキー名を一致させる必要がある
```

`dbt_project.yml` は dbt プロジェクト全体の設定ファイルで、プロジェクト名やモデルの設定などを管理しています。`profile` の値は、次に作成する `profiles.yml` のプロファイル名と一致させる必要があります。

#### DuckDB への接続情報を設定する

dbt のプロファイル（接続情報）は、`~/.dbt/profiles.yml` というファイルで管理されています（`~` はホームディレクトリを指します）。

このファイルがまだ存在しない場合は、`~/.dbt/` ディレクトリを作成し、手動でファイルを新規作成してください。以下の内容で記述します。

```yaml
# ~/.dbt/profiles.yml

jaffle_shop:          # dbt_project.yml の profile 名と一致させる
  outputs:
    dev:              # 環境名。複数の環境（dev/prod など）を定義できる
      type: duckdb    # 接続先データプラットフォームの種類
      path: jaffle_shop.duckdb  # DuckDB のデータファイル名（自動生成される）
      threads: 1      # 並列実行するスレッド数
  target: dev         # デフォルトで使用する環境名
```

| 項目 | 説明 |
| --- | --- |
| `jaffle_shop` | プロファイル名。`dbt_project.yml` の `profile` と一致させる |
| `outputs` | 接続先の環境を定義するセクション。開発（dev）・本番（prod）など複数定義できる |
| `dev` | 環境名。`target` で指定した環境がデフォルトで使用される |
| `type: duckdb` | 使用するデータプラットフォームの種類 |
| `path: jaffle_shop.duckdb` | DuckDB のデータベースファイルのパス。このファイルにデータが保存される |
| `threads: 1` | 並列実行するスレッド数 |
| `target: dev` | デフォルトで使用する環境 |

> **Note**：DuckDB はファイルベースのデータベースなので、BigQuery や Snowflake のようなホスト名・ポート番号・認証情報の設定は不要です。`path` に指定したファイルにデータが保存されます。

---

### 3.4 dbt debug による接続確認

プロファイルが正しく設定されているかを確認するために、`dbt debug` コマンドを実行します。設定ファイルの読み込みやデータプラットフォームへの接続テストなど、各種チェックを行います。

```bash
dbt debug
```

実行すると、以下のような項目が順番にチェックされます。

- dbt のバージョン
- `dbt_project.yml` の読み込み
- プロファイルファイルの確認
- データプラットフォームへの接続

全てのチェックが通ると、`All checks passed!` と表示されます。エラーが表示される場合は、以下のポイントを確認してください。

- `dbt_project.yml` の `profile` 名と `profiles.yml` のプロファイル名が一致しているか
- `profiles.yml` の YAML 構文が正しいか（インデントがスペースで統一されているか）
- `profiles.yml` のファイルパス（`~/.dbt/profiles.yml`）が正しいか
- dbt コマンドを `jaffle-shop` ディレクトリ内で実行しているか

---

### 3.5 dbt deps によるパッケージのインストール

jaffle-shop は、事前に使用するパッケージが `packages.yml` に定義されています。以下のコマンドでインストールします。

```bash
dbt deps
```

```yaml
# packages.yml
packages:
  # dbt Hub（公式レジストリ）からインストールする場合
  - package: dbt-labs/dbt_utils   # テストや SQL 生成に便利なマクロ集
    version: 1.3.3
  - package: godatadriven/dbt_date  # 日付処理に特化したマクロ集
    version: 0.17.1
  # GitHub リポジトリから直接インストールする場合
  - git: "https://github.com/dbt-labs/dbt-audit-helper.git"
    revision: main                  # ブランチ名やコミットハッシュを指定できる
```

このコマンドを実行すると、`packages.yml` に記載されたパッケージがダウンロードされ、`dbt_packages/` ディレクトリに配置されます。

> **パッケージの指定方法**
>
> - **dbt Hub 経由**：`package: dbt-labs/dbt_utils` のように、パッケージ名とバージョンを指定します。dbt Hub は dbt パッケージの公式レジストリです
> - **Git 経由**：`git: "https://..."` のように、Git リポジトリを直接指定します。公式レジストリに登録されていないパッケージや、特定のブランチを使いたい場合に便利です

---

### 3.6 dbt seed によるサンプルデータのロード

`dbt seed` コマンドを使って、jaffle-shop の架空データを DuckDB にロードします。このコマンドは、プロジェクト内の `seeds/` ディレクトリにある CSV ファイルを読み込み、接続先のデータプラットフォームにテーブルとして格納します。

```bash
dbt seed --full-refresh --vars '{"local_source_data": true}'
```

| オプション | 説明 |
| --- | --- |
| `--full-refresh` | 既存のテーブルを削除して新しくデータをロードし直す。2 回目以降の実行でもクリーンな状態にしたい場合に使う |
| `--vars '{"local_source_data": true}'` | dbt 内の変数 `local_source_data` を `true` に設定する。jaffle-shop ではこの変数が `true` の場合に `seeds/` ディレクトリのデータが参照されるよう `dbt_project.yml` で制御されている |

> **Note**：`--vars` オプションで設定した変数は、`dbt_project.yml` 内の `{% if var('local_source_data', false) %}` のように参照されています。デフォルト値は `false` なので、実行のたびに指定する必要があります。

実行が完了すると、顧客データ（`raw_customers`）、注文データ（`raw_orders`）、商品データ（`raw_products`）などが DuckDB にロードされます。

---

### 3.7 dbt run によるモデルの実行

いよいよ、dbt のメイン機能であるモデルの実行です。`dbt run` コマンドは、`models/` ディレクトリに配置された SQL モデルを実行し、DuckDB 上にビューやテーブルを作成します。

```bash
dbt run
```

`Completed successfully` と表示されれば処理成功です。ステージング層のモデルが先に作成され、その後にデータマート層のモデルが作成されます（ステージング層・データマート層については [4 章](#4-dbt-モデルの仕組み) で詳しく解説します）。

---

### 3.8 主な dbt コマンドのまとめ

| コマンド | 説明 |
| --- | --- |
| `dbt debug` | 設定ファイルと接続設定の検証 |
| `dbt deps` | 外部パッケージのインストール |
| `dbt seed` | CSV ファイルからデータをロード |
| `dbt run` | SQL モデルを実行してテーブル/ビューを作成 |
| `dbt test` | データ品質のテストを実行 |
| `dbt build` | seed・run・test をまとめて実行 |

---

## 4. dbt モデルの仕組み

### 4.1 dbt モデルとは

dbt におけるモデルとは、**データ変換処理を定義した SQL ファイル**のことです。

例えば、以下のようなデータ変換がモデルとして定義されます。

- カラム名をわかりやすく変換する（`id` → `customer_id`）
- 複数のテーブルを JOIN して分析しやすい形にする
- 集計指標（売上合計、顧客ごとの注文回数など）を計算する

各モデルは **一つの SELECT 文**で構成され、その出力結果がテーブルやビューとしてデータウェアハウスに保存されます。

> **Note**：モデルを記述する方法は SQL と Python の 2 通りありますが、本書では SQL モデルのみで解説します。SQL モデルは、dbt の基本的かつ広く使われているモデル記述方法です。

---

### 4.2 SQL ファイルと YAML ファイルはなぜセットか

dbt では、**SQL ファイル（変換ロジック）と YAML ファイル（ドキュメント・テスト設定）をペアで管理**します。

```text
models/staging/
├── stg_customers.sql   ← データ変換ロジック
├── stg_customers.yml   ← stg_customers のドキュメント・テスト設定
├── stg_orders.sql
└── stg_orders.yml
```

YAML ファイルには、対応するモデルの以下の情報を記述します。

```yaml
# stg_customers.yml の例
version: 2

models:
  - name: stg_customers          # 対応する SQL ファイルのモデル名
    description: 顧客データの前処理モデル
    columns:
      - name: customer_id
        description: 顧客の一意識別子
        tests:
          - not_null   # NULL を許容しない
          - unique     # 値が重複しない
      - name: customer_name
        description: 顧客の氏名
        tests:
          - not_null
```

このように、**SQL と YAML を対にすることで「ロジック・説明・テスト」を一か所で管理**できます。モデルが増えても、対応する YAML を見るだけで「このモデルが何をするものか」「どんなテストがかかっているか」がわかります。

`dbt test` を実行すると、YAML に定義されたテストが全モデル分まとめて実行されます。

---

### 4.3 CTE（Common Table Expression）

dbt のモデルでは、**CTE（Common Table Expression）** を多用します。CTE は、SQL の `WITH` 句を使って定義する「名前付きの一時的なクエリ結果」です。

```sql
-- CTE の基本構造
WITH
  cte_name AS (
    SELECT
      ...
    FROM some_table
  )
-- CTE を通常のテーブルのように参照できる
SELECT * FROM cte_name
```

jaffle-shop のモデルでは、このCTEを多段階に組み合わせることで、複雑なデータ変換処理をステップごとに分けて記述しています。各 CTE に意味のある名前（`source`、`renamed`、`joined` など）をつけることで、SQL の処理の流れが追いやすくなります。

```sql
-- 多段階 CTE の例：stg_customers.sql
WITH

-- ステップ1: 生データをそのまま取り込む
source AS (
    SELECT * FROM raw_customers
),

-- ステップ2: カラム名をわかりやすく変換する
renamed AS (
    SELECT
        id AS customer_id,
        name AS customer_name
    FROM source
)

-- 最終的に返すデータ
SELECT * FROM renamed
```

---

### 4.4 Jinja テンプレート記法

dbt の SQL ファイルには、通常の SQL に加えて **Jinja（ジンジャ）テンプレート** の記法が混在しています。Jinja は Python のテンプレートエンジンで、dbt はこれを使って SQL ファイル内に動的な処理を組み込んでいます。

dbt の実行時に Jinja の記法が解釈され、最終的な SQL に変換されます。

| 記法 | 用途 | 例 |
| --- | --- | --- |
| `{{ ... }}` | 値の出力（関数呼び出しなど） | `{{ ref('stg_orders') }}` |
| `{% ... %}` | 制御構文（条件分岐・ループ・マクロ定義など） | `{% if is_incremental() %}` |

本書で登場する主な Jinja 記法は `{{ ref(...) }}`、`{{ source(...) }}`、`{{ config(...) }}`、`{% macro %}` などです。それぞれ以降の節で説明します。

---

### 4.5 ref 関数と source 関数

dbt では、モデルから他のモデルやデータソースを参照するための専用の関数があります。

#### ref() 関数

`ref()` 関数は、**他の dbt モデルを参照**するために使います。

```sql
-- ref() を使ってステージング層のモデルを参照する
SELECT * FROM {{ ref('stg_orders') }}
-- dbt の実行時に上記は次のような SQL に展開される
-- SELECT * FROM jaffle_shop.stg_orders
```

`ref()` を使うことで dbt は次の２つを自動的に行います。

1. **実行順序の保証**：参照先のモデルが先に実行されるよう、実行順序を自動的に決定します
2. **データリネージの追跡**：モデル間の依存関係が DAG として記録され、ドキュメントで可視化できます

#### source() 関数

`source()` 関数は、**dbt プロジェクト外部のテーブル**（ローデータのテーブルなど）を参照するために使います。

```sql
-- source('ソース名', 'テーブル名') の形式で記述する
SELECT * FROM {{ source('ecom', 'raw_customers') }}
-- dbt の実行時に上記は次のような SQL に展開される
-- SELECT * FROM raw.raw_customers
```

ソースの定義は YAML ファイル（`__sources.yml`）で一元管理されます。

```yaml
# models/staging/__sources.yml
# （ファイル名先頭の __ は「モデルではなく設定ファイル」であることを示す慣習）
version: 2

sources:
  - name: ecom                    # source() の第1引数に対応するソース名
    schema: raw                   # データが格納されているスキーマ名
    description: E-commerce data for the Jaffle Shop
    tables:
      - name: raw_customers       # source() の第2引数に対応するテーブル名
        description: One record per person who has purchased one or more items
      - name: raw_orders
        description: One record per order (consisting of one or more order items)
```

`source()` で外部テーブルを一元管理することで、テーブル名やスキーマが変わった場合も YAML ファイルの一か所を修正するだけで済みます。また、ソーステーブルへの参照が `dbt test` の対象にもなるため、データ品質の監視にも役立ちます。

> **スキーマとは？**
> データベース内でテーブルをグループ化する名前空間のことです。`raw.raw_customers` のように「スキーマ名.テーブル名」の形式で参照します。ビジネスグループや用途ごとにスキーマを分けることで、アクセス制御や整理がしやすくなります。

---

### 4.6 モデルの 3 層構造

jaffle-shop のモデルは、データ変換の役割に応じて以下の 3 層に分かれています。

```text
データソース層（raw_ で始まるテーブル）
    ↓ seeds / EL ツールによるロード
ステージング層（stg_ で始まるモデル）
    ↓ 基本的な前処理
データマート層（customers、orders など）
    ↓ 最終的な集計・結合
```

#### データソース層

CSV ファイルや外部システムから直接ロードされた生データです。`raw_customers`、`raw_orders`、`raw_products` などのテーブルが相当します。

#### ステージング層

データソース層の生データに対して「基本的な前処理」を施した中間データです。

例：`stg_customers.sql`

```sql
WITH

-- ステップ1: source() でデータソース層のテーブルを取り込む
source AS (
    SELECT * FROM {{ source('ecom', 'raw_customers') }}
),

-- ステップ2: カラム名をわかりやすく変換する（id → customer_id など）
renamed AS (
    SELECT
        id AS customer_id,       -- 汎用的な id をモデル固有の名前に変更
        name AS customer_name
    FROM source
)

SELECT * FROM renamed
```

#### データマート層

ステージング層のモデルを組み合わせて、BI ツールやアプリケーションから直接参照される最終的なデータを作成する層です。

例：`order_items.sql`

```sql
WITH

-- ステージング層の各モデルを ref() で参照する
order_items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
),
orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),
products AS (
    SELECT * FROM {{ ref('stg_products') }}
),
supplies AS (
    SELECT * FROM {{ ref('stg_supplies') }}
),

-- 商品ごとの仕入れコスト合計を事前集計しておく（JOIN 前に集計するのが効率的）
order_supplies_summary AS (
    SELECT
        product_id,
        SUM(supply_cost) AS supply_cost
    FROM supplies
    GROUP BY 1
),

-- 全テーブルを結合して注文明細ごとの詳細情報を作成する
joined AS (
    SELECT
        order_items.*,
        orders.ordered_at,
        products.product_name,
        products.product_price,
        products.is_food_item,
        products.is_drink_item,
        order_supplies_summary.supply_cost
    FROM order_items
    LEFT JOIN orders
        ON order_items.order_id = orders.order_id
    LEFT JOIN products
        ON order_items.product_id = products.product_id
    LEFT JOIN order_supplies_summary
        ON order_items.product_id = order_supplies_summary.product_id
)

SELECT * FROM joined
```

`ref()` 関数で複数のステージング層モデルを参照しているため、dbt はそれらのモデルが先に実行されることを自動的に保証します。

---

### 4.7 マテリアライゼーション

**マテリアライゼーション**とは、dbt のモデルの実行結果を「どのような形式でデータウェアハウスに保存するか」を指定する設定です。適切なマテリアライゼーションを選択することで、パフォーマンスとコストを最適化できます。

#### dbt_project.yml での設定（ディレクトリ単位）

マテリアライゼーションは `dbt_project.yml` でディレクトリ単位に一括設定できます。

```yaml
# dbt_project.yml
models:
  jaffle_shop:    # プロジェクト名
    staging:      # models/staging/ 配下のモデルへの設定
      +materialized: view    # + は「dbt の設定項目」を示すプレフィックス
    marts:        # models/marts/ 配下のモデルへの設定
      +materialized: table
```

> **`+` プレフィックスとは？**
> `dbt_project.yml` でモデル設定を記述する際、`+` をつけた項目が「dbt の設定」であることを示す記号です。ディレクトリ名（`staging`、`marts`）と dbt の設定項目（`+materialized`、`+schema`）を区別するために使います。`+` がないとディレクトリ名として解釈されてしまいます。

#### モデルファイル内での設定（モデル個別）

ディレクトリ単位ではなく、特定のモデルだけ異なる設定にしたい場合は、モデルファイルの先頭に `{{ config() }}` ブロックを記述します。

```sql
{{
  config(
    -- このモデルだけ incremental にする
    -- dbt_project.yml の設定よりもこちらが優先される
    materialized='incremental'
  )
}}

SELECT * FROM {{ source('ecom', 'raw_orders') }}
```

> **`{{ config() }}` とは？**
> モデルファイル内でそのモデル固有の dbt 設定を記述するための Jinja 関数です。`dbt_project.yml` でディレクトリ単位に設定する方法と同じことができますが、**モデルファイル内の `config()` 設定の方が優先**されます。

#### table（テーブル）

モデルの実行結果をテーブルとして物理的に保存します。クエリが高速です。BI ツールなどから頻繁に参照されるデータマート層に適しています。

#### view（ビュー）

SQL のクエリ定義を保存したもので、参照するたびに SQL が実行されます。データを物理的に保存しないため、ストレージを消費しません。常に最新のソースデータを反映した結果が得られるというメリットもあります。

ステージング層のモデルは、データマート作成時に一時的に参照されるものであり、BI ツールなどから直接参照されることは想定していません。テーブルとして実体化してストレージを消費するよりも、ビューとして定義しておく方が効率的です。

#### incremental（増分更新）

毎回テーブルを全件作り直す（フルリフレッシュ）のではなく、新しく追加・変更されたレコードだけを更新します。大量データを扱う場合にビルド時間を大幅に短縮できます。

```sql
-- モデルファイル冒頭で incremental を指定する
{{
  config(
    materialized='incremental'
  )
}}

SELECT * FROM {{ source('ecom', 'raw_orders') }}

-- is_incremental() は「2回目以降の実行かどうか」を判定する dbt 組み込み関数
-- 初回実行時（テーブルが存在しない）は FALSE → WHERE 句なしで全件ロード
-- 2回目以降は TRUE → WHERE 句で差分レコードのみ取得
{% if is_incremental() %}
  WHERE ordered_at > (
    -- {{ this }} は「このモデル自身のテーブル」を参照する特殊な変数
    SELECT MAX(ordered_at) FROM {{ this }}
  )
{% endif %}
```

#### ephemeral（エフェメラル）

テーブルやビューとして実体化せず、参照元の SQL に CTE として埋め込まれるマテリアライゼーションです。データベースにオブジェクトが作成されないため、一時的な中間計算にのみ必要なケースに適しています。ただし、データベース上に実体がないため、デバッグ時に出力結果を直接確認しにくいというトレードオフがあります。

---

### 4.8 マクロ

**マクロ**とは、繰り返し使われる SQL 変換処理を **DRY（Don't Repeat Yourself：同じコードを繰り返さない）** に保つための仕組みです。Jinja テンプレートの `{% macro %}` 記法で定義し、関数のように複数のモデルから呼び出せます。

jaffle-shop の `cents_to_dollars` マクロを例に見てみましょう。

```sql
-- macros/cents_to_dollars.sql
-- このファイルには2つのマクロが定義されている

-- [1] エントリーポイントとなるマクロ（モデルから呼び出すのはこちら）
{% macro cents_to_dollars(column_name) -%}
  -- adapter.dispatch() は「接続先データベースに合わせた実装を自動選択する」仕組み
  -- 'cents_to_dollars' という名前の実装を、接続中のDBに合わせて探しに行く
  {{ return(adapter.dispatch('cents_to_dollars')(column_name)) }}
{%- endmacro %}

-- [2] デフォルト実装（DuckDB など多くのDBで使われる）
-- プレフィックス "default__" は「どのDBにも対応するデフォルト実装」を意味する慣習
{% macro default__cents_to_dollars(column_name) -%}
  {{ column_name }} / 100::numeric(16, 2)
{%- endmacro %}
```

> **`adapter.dispatch` とは？**
> 接続先のデータベースに応じてマクロの実装を切り替える仕組みです。例えば、DuckDB では `default__cents_to_dollars` が実行されますが、もし Snowflake 固有の書き方が必要なら `snowflake__cents_to_dollars` という名前でマクロを追加定義するだけで、Snowflake 接続時はそちらが自動的に使われるようになります。このパターンにより、同じマクロを複数のデータベースで動作させられます。

モデル内では以下のように呼び出します。

```sql
-- stg_order_items.sql（抜粋）
SELECT
  id AS order_item_id,
  -- cents_to_dollars マクロを呼び出して単位換算
  -- 展開後は: subtotal / 100::numeric(16, 2) AS subtotal
  {{ cents_to_dollars('subtotal') }} AS subtotal
FROM source
```

マクロを定義したら、`_macros.yml` で目的と引数の説明をドキュメント化しておくと、チームメンバーが再利用しやすくなります。

---

### 4.9 本章のまとめ

| 概念 | 説明 |
| --- | --- |
| モデル | データ変換処理を定義した SQL ファイル。SELECT 文で記述する |
| SQL + YAML のペア | SQL がロジック、YAML がドキュメントとテスト設定。セットで管理する |
| 3 層構造 | データソース層 → ステージング層 → データマート層の段階的変換 |
| `{{ }}` | Jinja の値出力タグ。`ref()`・`source()`・`config()` などで使う |
| `{% %}` | Jinja の制御構文タグ。マクロ定義・条件分岐などで使う |
| `source()` 関数 | `{{ source('name', 'table') }}` で外部データソースを参照 |
| `ref()` 関数 | `{{ ref('model') }}` で他の dbt モデルを参照。実行順序も保証される |
| `config()` | `{{ config(materialized='...') }}` でモデル固有の設定を記述 |
| DAG | モデル間の依存関係グラフ。dbt が自動生成し、実行順序を保証する |
| マテリアライゼーション | モデルの出力方法（table・view・incremental・ephemeral） |
| `+` プレフィックス | `dbt_project.yml` での dbt 設定項目を示す記号 |
| マクロ | 再利用可能な SQL テンプレート。`macros/` ディレクトリに定義する |
| `adapter.dispatch` | 接続先 DB に応じてマクロの実装を自動選択する仕組み |
| パッケージ | 外部の便利なマクロやテストを提供するライブラリ |

---

## 5. プロジェクト構造のベストプラクティス

ここからは、dbt 公式のベストプラクティスガイドをもとに、プロジェクトの構造について解説します。プロジェクトが成長するにつれて、適切なモデルの管理が重要になります。

---

### 5.1 全体像

dbt プロジェクトでは、データ変換の流れに沿って以下の 3 つの層にモデルを構成するのが一般的です。

| 層 | フォルダ | 役割 |
| --- | --- | --- |
| Staging 層 | `models/staging/` | データソースの前処理・標準化 |
| Intermediate 層 | `models/intermediate/` | Staging と Mart の間の中間処理（任意） |
| Mart 層 | `models/marts/` | BI ツール・アプリ向けの最終成果物 |

jaffle-shop のプロジェクト構造は以下のようになっています。各 SQL ファイルに対して同名の YAML ファイル（ドキュメント・テスト設定）が対になっています。

```text
jaffle-shop/
├── dbt_project.yml            # プロジェクト全体の設定ファイル
├── packages.yml               # 外部パッケージの定義
├── macros/
│   ├── cents_to_dollars.sql   # 独自マクロの定義
│   └── generate_schema_name.sql
└── models/
    ├── staging/
    │   ├── __sources.yml      # ソース定義（__ はモデルではなく設定ファイルの印）
    │   ├── stg_customers.sql  # 変換ロジック
    │   ├── stg_customers.yml  # ドキュメント・テスト設定（SQL とペア）
    │   ├── stg_orders.sql
    │   ├── stg_orders.yml
    │   ├── stg_order_items.sql
    │   ├── stg_order_items.yml
    │   ├── stg_products.sql
    │   ├── stg_products.yml
    │   ├── stg_supplies.sql
    │   └── stg_supplies.yml
    └── marts/
        ├── customers.sql
        ├── customers.yml
        ├── orders.sql
        ├── orders.yml
        ├── order_items.sql
        ├── order_items.yml
        ├── products.sql
        ├── products.yml
        ├── supplies.sql
        └── supplies.yml
```

---

### 5.2 Staging 層

#### 役割

データソースをもとに、後続モデルで使いやすい「部品」を作る最初の層です。基本的な前処理（カラム名の変更・型変換など）を行い、ビジネスロジックは含まない形にします。

#### ファイル命名規則

`stg_[entity].sql` のようにプレフィックスを使ったファイル名にします。`stg_` プレフィックスにより、Staging 層のモデルをファイル名だけで特定できます。

データソースが複数ある場合は、`stg_[source]_[entity].sql` のようにソース名を含めた命名を行います。

#### フォルダ構成

- **推奨**：データソースに紐づいてサブディレクトリを構成する
- **非推奨**：ビジネスグループごとにサブディレクトリを分ける

Staging 層はデータソースごとに整理するのが自然です。ビジネスグループごとに分けてしまうと、同じデータソースのテーブルが複数のディレクトリに散らばり、管理が複雑になります。

jaffle-shop は単一のデータソース（ecom）なので、`models/staging/` ディレクトリに全てのステージングモデルをフラットに配置しています。

#### マテリアライゼーション

**view** にします。下流のモデルは常に最新のソースデータにアクセスでき、かつ不要なストレージを消費しません。

#### やってはいけないこと（アンチパターン）

| アンチパターン | 理由 |
| --- | --- |
| JOIN の実行 | Staging 層のモデルは下流で様々な組み合わせで利用される可能性があるため、JOIN してしまうと再利用が難しくなる |
| 集約処理（GROUP BY など） | 粒度（1 行が何を表すか）が変わってしまい、下流モデルの設計が困難になる |

#### codegen でモデル作成を自動化する

`codegen` という dbt パッケージを使うと、データソースに対応した Staging モデルのコードを自動生成できます。

```yaml
# packages.yml に追加
packages:
  - package: dbt-labs/codegen
```

```bash
# パッケージをインストール
dbt deps

# generate_base_model マクロを実行してモデルのテンプレートを生成する
# dbt run-operation はモデルではなくマクロを直接実行するコマンド
dbt run-operation generate_base_model --args \
  '{"source_name": "ecom", "table_name": "raw_customers"}'
```

> **`dbt run-operation` とは？**
> モデルの実行（`dbt run`）ではなく、**マクロを直接実行**するコマンドです。`generate_base_model` のように「コードを自動生成する」「データを検証する」といった補助作業に使います。実行結果はターミナルに出力されるだけで、データウェアハウスにはテーブルを作成しません。

コマンドラインに Staging モデルのテンプレートコードが出力されるので、これをコピーして `stg_customers.sql` のベースとして利用できます。

---

### 5.3 Intermediate 層

#### 役割

Staging 層と Mart 層の間に位置する層です。特定のビジネス目的に応じたデータ変換を行い、Mart 層のモデルをシンプルに保つことを目的とします。

**導入タイミング**：JOIN が 5 つ以上になる Mart 層モデルが出てきたら、Intermediate 層への切り出しを検討しましょう。小規模なプロジェクトでは不要です。

#### ファイル命名規則

`int_[verb].sql` のように動詞を使ったファイル名にします。

```text
int_supply_costs_aggregated_to_products.sql
     ↑     ↑         ↑              ↑
   prefix  対象  処理の種類（集計）  集計先の粒度
```

ファイル名を見ただけで「どのような変換処理を行っているか」がわかるようになります。

#### フォルダ構成

ビジネスグループに基づいてサブディレクトリを構成します。

```text
models/intermediate/
├── finance/
│   └── int_payment_provider_to_orders.sql
└── marketing/
    └── int_orders_aggregated_to_customers.sql
```

Staging 層と異なり、Intermediate 層はビジネス目的（finance、marketing など）に応じた処理を行うため、ビジネスグループ単位での整理が自然です。

#### モデルの例

```sql
-- int_supply_costs_aggregated_to_products.sql
-- 商品ごとの仕入れコストを集計する（Mart 層で繰り返し書かずに済むよう切り出す）
WITH

supplies AS (
    SELECT * FROM {{ ref('stg_supplies') }}
),

-- 商品 ID ごとに仕入れコストを合計する（粒度：1行 = 1商品）
aggregate_to_product AS (
    SELECT
        product_id,
        SUM(supply_cost) AS supply_cost  -- NULL は 0 として扱う場合は COALESCE を使う
    FROM supplies
    GROUP BY 1
)

SELECT * FROM aggregate_to_product
```

#### Intermediate 層の主な役割

- **データ粒度の変換**：「1 レコード 1 注文明細」から「1 レコード 1 商品」のように、データの粒度を変える処理は Intermediate 層で実装します。下流の複数モデルが同じ集計処理を重複して書くのを防げます。
- **複雑な集計の整理**：複雑なデータ変換処理を Intermediate 層に封じ込めることで、下流の Mart 層をシンプルに保ち、デバッグやリファクタリングをしやすくします。

---

### 5.4 Mart 層

#### 役割

Staging 層・Intermediate 層で作った「部品」を組み合わせて、**BI ツールやアプリケーションから直接参照される最終的なデータマート**を作る層です。1 行が 1 つのビジネスエンティティ（1 顧客、1 注文など）に対応するデータを提供します。

#### ファイル命名規則

プレフィックスなしのシンプルな名前を使います（`customers`、`orders`、`products` など）。そのモデルが表すビジネスエンティティの名前をそのまま使います。

#### フォルダ構成

ビジネスグループに紐づいてサブディレクトリを持たせる構成が推奨されます。

```text
models/marts/
├── finance/
│   ├── _finance_models.yml    # finance 配下のモデルを一括定義
│   └── orders.sql
└── marketing/
    ├── _marketing_models.yml
    └── customers.sql
```

jaffle-shop は小規模なプロジェクトのため、`models/marts/` ディレクトリに全てのモデルがフラットに配置されています。

#### マテリアライゼーション

**table** にします。Mart 層のモデルはエンドユーザーが直接クエリするため、クエリのたびに SQL が再実行されるビューよりも、事前に計算済みのテーブルの方が応答速度が速くなります。

#### やってはいけないこと（アンチパターン）

**同じ専門領域のモデルを複数作らない**

例えば `finance_orders` と `marketing_orders` のように、同じ領域を目的別に複数のモデルとして作ってしまうと、どちらが正しい数値なのかが不明確になります（**Single Source of Truth：信頼できる唯一の情報源** の原則が損なわれます）。メンテナンスの負担も増えます。

一つの `orders` モデルを持ち、全ての利用者はそこを参照するようにしましょう。

---

### 5.5 YAML 設定ファイルの管理

dbt プロジェクトでは、モデルのドキュメントやテストの設定を YAML ファイルで管理します。

#### 推奨：ディレクトリごとに YAML ファイルを作成する

```text
models/staging/
├── _staging_models.yml    # staging 配下のモデルを一括でドキュメント・テスト設定
├── _staging_sources.yml   # ソース定義
├── stg_customers.sql
└── stg_orders.sql

models/marts/
├── _marts_models.yml      # marts 配下のモデルを一括でドキュメント・テスト設定
├── orders.sql
└── customers.sql
```

ファイル名の先頭にアンダースコアをつけることで、ディレクトリ内で YAML ファイルが常に上部にソートされ、見つけやすくなります。

> **Note**：jaffle-shop では各モデルごとに個別の YAML ファイル（`orders.yml`、`customers.yml` など）を用意しています。これは「テストが定義されていないモデルを発見しやすい」というメリットがある一方、ファイル数が増えるというトレードオフもあります。重要なのはチーム内で一貫性を保つことです。

#### dbt_project.yml でのカスケード設定

`dbt_project.yml` を活用すると、ディレクトリ単位でマテリアライゼーションやスキーマを一括設定できます。

```yaml
# dbt_project.yml
models:
  jaffle_shop:          # プロジェクト名
    staging:            # models/staging/ 配下に適用
      +materialized: view    # view として出力（+ は dbt 設定項目の印）
    marts:              # models/marts/ 配下に適用
      +materialized: table   # table として出力
    finance:            # models/finance/ 配下に適用
      +schema: finance       # 出力先スキーマを finance に変更
```

---

### 5.6 その他の構成要素

#### Seeds

CSV ファイルからデータをロードする機能です。

**適切な用途**

- 郵便番号と都道府県の対応表
- 従業員 ID と顧客 ID のマッピング
- 国コードや通貨コードの参照テーブル

変更頻度が低く、小規模なルックアップテーブルに適しています。

**アンチパターン**：ソースシステムからのデータロードに Seeds を使わない。それは EL（Extract/Load）ツールの役割です。jaffle-shop では Seeds を使ってサンプルデータをロードしていますが、これはあくまで学習・デモ目的です。

#### Analyses

Jinja テンプレートを使用できるが、データウェアハウスにテーブルやビューとしてデプロイされない SQL ファイルを格納するディレクトリです。マイグレーション時の検証クエリなど、一時的な分析クエリの管理に使います。

#### Data Tests

データ品質を検証するテストには 2 種類あります。

| 種類 | 定義方法 | 用途 |
| --- | --- | --- |
| **Generic Test** | YAML ファイルで宣言的に定義 | not_null、unique、accepted_values などの標準的なテスト |
| **Singular Test** | SQL ファイルとして定義 | 複数モデルにまたがる統合テストなど複雑なケース |

Generic Test で大半のテストケースはカバーできますが、複雑な検証が必要な場合は Singular Test を使います。テストファイルは `data-tests/` ディレクトリに配置します。

```sql
-- data-tests/assert_order_total_is_positive.sql
-- Singular Test は「問題のあるレコードを返す SELECT 文」として書く
-- このクエリが 0 行を返せばテスト成功、1 行以上返すとテスト失敗となる
SELECT
    order_id,
    order_total
FROM {{ ref('orders') }}
WHERE
    order_total <= 0    -- 注文合計がゼロ以下のレコードを検出する
```

---

### 5.7 プロジェクト構造のまとめ

| 層 | フォルダ構成 | 命名規則 | マテリアライゼーション |
| --- | --- | --- | --- |
| Staging | データソース別サブディレクトリ | `stg_[entity].sql` | view |
| Intermediate | ビジネスグループ別サブディレクトリ | `int_[verb].sql` | ephemeral または view |
| Mart | ビジネスグループ別サブディレクトリ | `[entity].sql` | table または incremental |

最も重要なのは、**チーム内で規則を統一し、一貫性を保つこと**です。ここで紹介したベストプラクティスはあくまでガイドラインです。プロジェクトの規模やチームの事情に合わせてカスタマイズしつつ、決めたルールはドキュメント化して全員が参照できるようにしておきましょう。

---

### 5.8 プロジェクト成長のロードマップ

**スモールスタート（モデル数 1〜10）**

Staging 層と Mart 層の 2 層構造で十分です。jaffle-shop のようにシンプルな構造から始めましょう。Intermediate 層は不要です。

**成長期（モデル数 10〜50）**

JOIN が 5 つ以上になる Mart 層モデルが出てきたら、Intermediate 層の導入を検討します。YAML 設定ファイルの構成もディレクトリ単位に整理します。

**成熟期（モデル数 50 以上）**

ビジネスグループ別のサブディレクトリ構成を導入し、アクセス制御やカスタムスキーマの設定も検討します。codegen などの自動化ツールを活用して、新規モデル作成の効率化を図りましょう。

いずれの段階でも、「今の規模に合った構造」を選択することが大切です。将来を見越して過度に複雑な構造を作り込む必要はありません。プロジェクトやチームの事情に合わせて、段階的に構造を進化させていきましょう。
