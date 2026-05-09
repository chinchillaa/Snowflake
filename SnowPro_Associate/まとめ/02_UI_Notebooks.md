# Snowflake UI & Notebooks

> SOL-C01 対応 | 出題比率: 15%
> このファイルでは、Snowflakeを操作するためのインターフェースについて学びます。
> 最終更新: 2026年3月

---

## 1. Snowsight（Web UI）

### 1.1 Snowsightとは

**Snowsight**はSnowflakeの**Webベースのユーザーインターフェース**です。ブラウザからアクセスし、SQLの実行からデータの可視化、管理作業まで行えます。

> **Note**: 以前存在したClassic Consoleは**廃止**されています。現在はSnowsightのみが使用されます。

### 1.2 アクセス方法

```
https://<account_identifier>.snowflakecomputing.com
```

- ブラウザでアクセス
- ユーザー名とパスワード（+ MFA）でログイン
- ソフトウェアのインストール不要

### 1.3 ナビゲーション構造

Snowsightの主要なナビゲーションメニュー：

```
├── Projects（プロジェクト）
│   ├── Worksheets      ← SQLエディタ
│   ├── Workspaces      ← 統合開発環境（新機能）
│   ├── Notebooks       ← インタラクティブ開発
│   ├── Dashboards      ← 可視化
│   └── Streamlit       ← アプリ開発
├── Data（データ）
│   ├── Databases       ← データベース管理
│   └── Private Sharing ← データ共有
├── AI & ML             ← Cortex機能
├── Monitoring          ← 監視
├── Admin               ← 管理機能
└── Marketplace         ← 外部データ取得
```

### 1.4 主な機能と使用シーン

| カテゴリ | 機能 | 実際の使用シーン |
|---------|------|-----------------|
| **クエリ実行** | Worksheets / Workspaces | 日常的なSQL作業、データ抽出 |
| **開発** | Notebooks | データ分析、機械学習の試行錯誤 |
| **可視化** | Charts、Dashboards | 経営レポート、KPI監視 |
| **アプリ開発** | Streamlit | 社内ツール、データアプリ |
| **管理** | Admin画面 | ユーザー管理、コスト監視 |
| **データ取得** | Marketplace | 外部データの発見・取得 |

### 1.5 オブジェクトブラウザ

Snowsightの左サイドバーにある「**オブジェクトブラウザ**」は、データベース・スキーマ・テーブルなどの**オブジェクトを一覧表示・フィルタリング**する機能です。

```
サイドバー（オブジェクトブラウザ）:
├── [検索ボックス] ← オブジェクト名でフィルタリング
├── 📁 SALES_DB
│   ├── 📁 PUBLIC（スキーマ）
│   │   ├── 📋 CUSTOMERS（テーブル）
│   │   ├── 📋 ORDERS
│   │   └── 👁 SALES_SUMMARY（ビュー）
│   └── 📁 ANALYTICS
└── 📁 REPORTING_DB
```

**主な用途**:
- テーブルやビューを探す
- スキーマ内のオブジェクトを一覧確認
- オブジェクト名の一部で絞り込み（フィルタリング）
- テーブルをクリックして詳細情報を確認

### 1.6 テーブルプレビュー

Snowsightでテーブルをクリックすると、データの**先頭100行がプレビュー**として表示されます。

```
CUSTOMERS テーブルのプレビュー:
┌────────────────────────────────────────┐
│ テーブル詳細                            │
│ 行数: 50,000  |  サイズ: 2.3 MB        │
├────────────────────────────────────────┤
│ プレビュー（最初の100行）               │
│ id | name | email | region           │
│ 1  | 田中 | tanaka@... | APAC       │
│ 2  | 佐藤 | sato@...   | APAC       │
│ ...（100行まで表示）                   │
└────────────────────────────────────────┘
```

> **ポイント**: プレビューは常に最初の100行のみ。全データを確認したい場合はSELECTクエリを使用します。

### 1.7 スキーマ詳細ページでの操作

Snowsightのスキーマ詳細ページでは、以下の操作が可能です：

- **スキーマの名前変更** : メニューから「Rename」を選択
- スキーマ内のテーブル・ビュー・ステージなどの一覧確認
- スキーマのプロパティ（Data Retention期間等）の確認

### 1.8 データロードUI（Snowsightによるファイルアップロード）

Snowsightにはデータを手動でアップロードするGUIインターフェースがあります。

> **なぜGUIでのデータロードが便利か**:
> - **データ型の自動検出**: CSVファイルを読み込むと、各列のデータ型（数値/文字列/日付など）を自動的に判定してくれる
> - **レコードの直接挿入**: 新しいテーブルにファイルをアップロードして、そのままデータを挿入（INSERT）できる
> - **プレビュー確認**: ロード前にデータを確認できる
> - **少量データ向け**: 大量データ（数万件以上）はCOPY INTOが推奨

**利用方法**: Data → Databases → テーブルを選択 → 「Load Data」ボタン

---

## 2. Worksheets と Workspaces

### 2.1 WorksheetsからWorkspacesへの移行

Snowflakeでは**2025年9月から順次、WorksheetsからWorkspacesへの移行**が進んでいます。

| 項目 | Worksheets（従来） | Workspaces（新） |
|------|-------------------|------------------|
| **位置づけ** | 従来のSQLエディタ | 統合開発環境 |
| **対応言語** | SQL | SQL、Python |
| **ファイル管理** | ワークシート単位 | フォルダ・ファイルベース |
| **Git連携** | なし | **あり**（バージョン管理可能） |
| **同時実行** | 1クエリずつ | **2クエリ同時実行可能** |
| **将来** | 将来的に非推奨予定 | 今後の標準 |

> **試験について**: 現時点ではWorksheetsとWorkspacesの両方が使用されています。試験ではWorksheets/Workspaces両方の概念が出題される可能性があります。

### 2.2 Worksheets（ワークシート）

SQLクエリを**記述・実行・保存**するための作業スペースです。

**アクセス方法**: Projects » Worksheets

> **なぜワークシートが便利か**
> - 複数のワークシートを**タブ形式**で同時に開ける
> - クエリを保存して**再利用**できる
> - 他のユーザーと**共有**できる
> - 実行結果を**チャートとして可視化**できる

### 2.3 基本的な使い方（Worksheets）

```sql
-- 1. コンテキストを設定（どのリソースを使うか）
USE ROLE analyst_role;
USE WAREHOUSE analytics_wh;
USE DATABASE sales_db;
USE SCHEMA public;

-- 2. クエリを実行
SELECT
    product_category,
    SUM(amount) as total_sales
FROM sales
GROUP BY product_category
ORDER BY total_sales DESC;

-- 3. 結果をチャートで可視化（ワークシート内で設定可能）
```

### 2.4 コンテキスト設定（重要）

ワークシートには4つのコンテキスト設定があり、**必須項目と任意項目**に分かれています。

| 設定項目 | 必須/任意 | 説明 | 設定しないとどうなる |
|---------|:--------:|------|------------------|
| **Role（ロール）** | **必須** | 操作に使用するロール。アクセス権限を決める | デフォルトロールが使われる |
| **Warehouse** | **必須** | クエリ実行に使用するコンピュートリソース | SELECT文の実行時にエラーが発生 |
| **Database** | 任意 | デフォルトのデータベース（ホームベース） | テーブル参照時に完全修飾名が必要になる |
| **Schema** | 任意 | デフォルトのスキーマ（ホームベース） | テーブル参照時に完全修飾名が必要になる |

```
なぜ Role と Warehouse は必須なのか？

Role → 「誰が」実行するかを定義。権限チェックに必須。
Warehouse → 「どこで」計算するかを定義。計算リソースなしにクエリは動かない。

Database / Schema は「どこを探すかのデフォルト」であり、
完全修飾名（db.schema.table）を書けば設定がなくても動く。
```

> **ポイント**: コンテキスト設定はワークシートごとに独立しています。あるワークシートの設定を変えても、他のワークシートには影響しません。ロールを変更した後はブラウザをリフレッシュすると確実に反映されます。

### 2.5 SHOW コマンド

> 🔗 **検証SQL**: [`verification/02_ui_notebooks/01_show_commands.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/02_ui_notebooks/01_show_commands.sql)

オブジェクトの一覧をSQL文で確認できるコマンドです。UIのオブジェクトブラウザと同じ情報をテキストとして取得できます。

```sql
-- データベース一覧（現在のロールがアクセスできるもの）
SHOW DATABASES;

-- スキーマ一覧（現在のデータベースコンテキスト内）
SHOW SCHEMAS;

-- スキーマ一覧（アカウント全体・全データベース）
SHOW SCHEMAS IN ACCOUNT;

-- テーブル一覧
SHOW TABLES;
SHOW TABLES IN SCHEMA garden_plants.veggies;

-- 関数一覧
SHOW FUNCTIONS IN ACCOUNT;
```

| コマンド | 範囲 | コンテキストの影響 |
|---------|------|-----------------|
| `SHOW SCHEMAS` | 現在のDatabaseのスキーマ | Databaseコンテキストに依存 |
| `SHOW SCHEMAS IN ACCOUNT` | 全データベースのスキーマ | コンテキスト不要 |

> **活用場面**: オブジェクトが見つからないとき、SHOW コマンドで「そもそも存在するか」「正しい名前か」を確認するのが有効です。

### 2.6 TOP / LIMIT による行数制限

> 🔗 **検証SQL**: [`verification/02_ui_notebooks/02_limit_top.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/02_ui_notebooks/02_limit_top.sql)

クエリ結果の行数を制限するには、`TOP` または `LIMIT` キーワードを使います。

```sql
-- LIMITを使って上位5行を取得（Snowflake標準）
SELECT * FROM sales LIMIT 5;

-- TOP（SQL Server方言。Snowflakeでも使用可能）
SELECT TOP 5 * FROM sales;

-- 両方まったく同じ結果になる
```

> **重要 ★試験頻出**: `LIMIT` を単独で使用し `ORDER BY` を指定しない場合、**どの行が返されるかは非決定的（不定）** です。
> 同じクエリを実行しても毎回異なる行が返る可能性があります。

```sql
-- 危険な例: ORDER BYなしのLIMITは毎回異なる行が返りうる
SELECT * FROM sales LIMIT 10;       -- 非決定的（不安定）

-- 正しい例: ORDER BYを付けることで結果が確定する
SELECT * FROM sales ORDER BY sale_date DESC LIMIT 10;  -- 安定
```

### 2.7 便利な機能

| 機能              | 説明              | ショートカット         |
| --------------- | --------------- | --------------- |
| **自動補完**        | テーブル名やカラム名の候補表示 | 入力中に自動表示        |
| **シンタックスハイライト** | SQLキーワードの色分け    | 自動適用            |
| **クエリ実行**       | 選択部分またはすべてを実行   | Ctrl + Enter    |
| **フォーマット**      | SQLの整形          | 右クリックメニュー       |
| **履歴**          | 過去のクエリ参照        | Query Historyから |

### 2.8 フォルダ管理と共有

```
My Worksheets/
├── 日次レポート/
│   ├── 売上サマリー.sql
│   └── 在庫確認.sql
├── 月次分析/
│   └── 顧客分析.sql
└── 共有フォルダ/（チームと共有）
    └── チーム用クエリ.sql
```

- ワークシートを**フォルダで整理**可能
- 特定のロールやユーザーに**共有**可能
- 共有されたワークシートは**編集権限を制御**できる

### 2.9 Workspaces（ワークスペース）

**アクセス方法**: Projects » Workspaces

Workspacesは2025年9月から導入された**新しい統合開発環境**です。

**Workspacesの特徴**:
- **ファイルベースの管理**: SQLやPythonを複数ファイルで管理
- **Git連携**: リポジトリとの接続、push/pullが可能
- **スプリットスクリーン**: 複数ファイルを並べて表示
- **同時クエリ実行**: 同一SQLファイルから2つのクエリを同時実行可能
- **プロジェクト単位の開発**: dbtプロジェクトなど複合的な開発に最適

```
Workspace/
├── models/
│   ├── sales_summary.sql
│   └── customer_analysis.sql
├── scripts/
│   └── data_pipeline.py
└── README.md
```

**管理者設定**:
- 管理者は「Workspacesをデフォルトエディタにする」設定が可能
- 設定 → アカウント設定からデフォルトエディタを選択

---

## 3. Snowflake Notebooks

### 3.1 Notebooksとは

**インタラクティブな開発環境**で、コード、実行結果、説明文を1つのドキュメントにまとめられます。**SQL・Python・Markdown（テキスト装飾）** を同じ画面でセル単位に実行・記録できます。

> **Jupyter Notebookをご存知の方へ**
> Snowflake NotebooksはJupyter Notebookに似た概念ですが、Snowflake内で完結し、データの移動が不要という大きなメリットがあります。

### 3.2 ワークシートとNotebooksの違い

| 項目          | Worksheets | Notebooks           |
| ----------- | ---------- | ------------------- |
| **対応言語**    | SQLのみ      | SQL、Python、Markdown |
| **実行単位**    | 全体または選択部分  | セル単位                |
| **ドキュメント性** | 低い（クエリのみ）  | 高い（説明文、グラフを含む）      |
| **適した用途**   | 定型的なSQL作業  | 探索的データ分析、ML開発       |

### 3.3 セルの種類

Notebooksは複数の「セル」で構成され、各セルに異なる種類のコンテンツを書けます。

```
┌─────────────────────────────────────────────────────┐
│ [Markdown] # 売上分析レポート                        │
│            2026年3月の売上データを分析します          │
├─────────────────────────────────────────────────────┤
│ [SQL] SELECT * FROM sales                           │
│       WHERE sale_date >= '2026-03-01'               │
│       実行結果: [テーブル表示]                        │
├─────────────────────────────────────────────────────┤
│ [Python] import pandas as pd                        │
│          df = session.table("sales").to_pandas()    │
│          df.describe()                              │
│          実行結果: [統計サマリー]                     │
├─────────────────────────────────────────────────────┤
│ [Python] import matplotlib.pyplot as plt            │
│          df.plot(kind='bar')                        │
│          実行結果: [グラフ表示]                       │
└─────────────────────────────────────────────────────┘
```

### 3.4 Notebooksの変数参照（{{myvar}}構文）

NotebooksのSQLセルやPythonセルでは、**`{{変数名}}`** という書き方で変数を参照できます。

> **{{myvar}}構文（Jinjaテンプレート）とは？**
> `{{` と `}}` で囲んだ名前を「変数の埋め込み場所」として指定する書き方です。ワークシートの「変数」テキストボックスに値を入力すると、その値がSQLに自動的に埋め込まれます。

```sql
-- SQLセルでの変数使用例
SELECT * FROM sales
WHERE region = '{{target_region}}'
LIMIT {{row_limit}};
```

```
実行前: Notebookの変数欄で
  target_region = 'APAC'
  row_limit = 100
と入力すると、以下のSQLとして実行される：

SELECT * FROM sales WHERE region = 'APAC' LIMIT 100;
```

**用途**:
- 異なるパラメータで同じ分析を繰り返す
- ユーザーが値を変えながら探索的に分析する
- テンプレートのように再利用できる分析を作る

### 3.5 Snowpark統合

NotebooksではSnowpark（PythonからSnowflakeを操作するライブラリ）が利用できます。

```python
# セッションは自動的に利用可能（設定不要）
from snowflake.snowpark.functions import col, sum as sum_

# Snowflakeテーブルをデータフレームとして操作
df = session.table("sales")

# フィルタと集計（Snowflake内で実行される）
result = df.filter(col("region") == "APAC") \
           .group_by("product") \
           .agg(sum_("amount").alias("total"))

result.show()
```

> **Snowparkとは？**
> PythonやScalaでSnowflake上のデータを操作できるライブラリ。データをローカルに持ってこずに、**Snowflake内で処理を実行**できるため、大量データでも高速に処理可能です。

### 3.6 Notebooksの使用シーン

| シーン | 具体例 |
|--------|--------|
| **探索的データ分析** | 新しいデータセットの傾向を調査 |
| **機械学習開発** | モデルの構築とチューニング |
| **レポート作成** | 分析結果とグラフ、説明を1つに |
| **教育・共有** | 分析手法をチームに説明 |

---

## 4. ダッシュボード

### 4.1 ダッシュボードとは

複数のクエリ結果（チャート）を**1つの画面にまとめて表示**する機能です。

> **実務での使われ方**
> 経営陣向けのKPIダッシュボード、営業チームの進捗管理、システム監視など、定期的に確認したい指標をまとめて表示します。

### 4.2 作成の流れ

```
1. ワークシートでクエリを実行
        ↓
2. 結果を「Chart」として可視化
        ↓
3. 「Add to Dashboard」でダッシュボードに追加
        ↓
4. レイアウトを調整（ドラッグ＆ドロップ）
        ↓
5. 共有設定で他ユーザーに公開
```

### 4.3 チャートの種類

| チャート | 適した用途 | 例 |
|---------|-----------|-----|
| **棒グラフ** | カテゴリ間の比較 | 地域別売上 |
| **折れ線グラフ** | 時系列の変化 | 月次売上推移 |
| **円グラフ** | 構成比の表示 | 売上比率 |
| **散布図** | 2変数の関係 | 価格と販売数の相関 |
| **数値タイル** | 単一KPIの強調表示 | 総売上金額 |

### 4.4 更新とスケジュール

- ダッシュボードを開くと**最新データ**でクエリが実行される
- 定期的な自動更新も設定可能
- 注意: Warehouseが必要（課金が発生）

---

## 5. Query History（クエリ履歴）

> 🔗 **検証SQL**: [`verification/02_ui_notebooks/03_query_history.sql`](https://github.com/chinchillaa/snowflake_lessons/blob/main/verification/02_ui_notebooks/03_query_history.sql)

### 5.1 Query Historyとは

**過去に実行されたクエリの履歴**を確認できる機能です。

> **実務での活用場面**
> - 以前実行したクエリを再利用したい
> - 特定のクエリがなぜ遅かったか調査したい
> - 誰がいつ何を実行したか監査したい

### 5.2 アクセス方法

Monitoring → Query History

### 5.3 確認できる情報

| 項目                | 説明             | 活用場面        |
| ----------------- | -------------- | ----------- |
| **Query ID**      | クエリの一意識別子      | サポートへの問い合わせ |
| **SQL Text**      | 実行されたSQL文      | クエリの再利用     |
| **Status**        | 成功/失敗/実行中      | エラー調査       |
| **Duration**      | 実行時間           | パフォーマンス分析   |
| **Warehouse**     | 使用されたWarehouse | コスト分析       |
| **User**          | 実行したユーザー       | 監査          |
| **Bytes Scanned** | スキャンされたデータ量    | 効率性の確認      |

### 5.4 フィルタリング

```
フィルタ条件:
├── 期間: 過去1時間、24時間、7日間、カスタム
├── ユーザー: 自分のみ、特定ユーザー、全員
├── ステータス: 成功、失敗、実行中
├── Warehouse: 特定のWarehouse
└── キーワード: SQL文に含まれる文字列
```

---

## 6. Query Profile（クエリプロファイル）

### 6.1 Query Profileとは

クエリの**実行計画と詳細な統計情報**を視覚的に確認できるツールです。

> **なぜ重要か**
> クエリが遅い原因を特定し、最適化するために不可欠です。試験でもQuery Profileの読み方は出題されます。

### 6.2 アクセス方法

1. Query Historyで対象クエリを選択
2. 「Query Profile」タブをクリック

### 6.3 読み方のポイント

```
クエリプロファイルの構造例:

[TableScan: customers]  ← 100万行スキャン
        ↓
[Filter: region = 'APAC']  ← 10万行に絞り込み
        ↓
[Aggregate: SUM(amount)]  ← 集計処理
        ↓
[結果: 1行]
```

### 6.4 重要な統計指標

| 指標 | 意味 | 改善のヒント |
|------|------|-------------|
| **Bytes Scanned** | スキャンしたデータ量 | 大きすぎる→クラスタリング検討 |
| **Partitions Scanned** | スキャンしたパーティション数 | 多い→WHERE句で絞り込み |
| **Percentage Scanned** | 全体に対するスキャン率 | 高い→フィルタ条件を見直し |
| **Spillage** | メモリ不足でディスクへ溢れた量 | 発生→Warehouseサイズ拡大 |
| **Queue Time** | 実行待ち時間 | 長い→Warehouse追加検討 |

### 6.5 よくあるボトルネックと対策

| 症状                      | 原因             | 対策                      |
| ----------------------- | -------------- | ----------------------- |
| Bytes Scannedが非常に大きい    | 不要なカラムを取得      | SELECT *を避け必要なカラムのみ     |
| Partitions Scannedが100% | WHERE句が効いていない  | フィルタ条件を追加               |
| Spillageが発生             | 中間結果がメモリに収まらない | Warehouseサイズを上げる        |
| Queue Timeが長い           | Warehouseが混雑   | 別Warehouseを使用、またはサイズアップ |

---

## 7. Streamlit in Snowflake

### 7.1 Streamlitとは

**Pythonで書けるWebアプリケーションフレームワーク**です。Snowflake内で直接構築・実行できます。

> **従来のBI/ダッシュボードとの違い**
> ダッシュボードは表示がメインですが、Streamlitはユーザー入力を受け付けて**インタラクティブな操作**が可能です（フォーム入力、ボタン操作など）。

### 7.2 特徴

Streamlit in Snowflake（SiS）は、**Pythonのコードのみで**、ドロップダウン・ボタン・入力フォームなどを持つデータアプリケーションを作成できます。HTMLやCSS、JavaScriptの知識は不要です。

| 特徴 | 説明 | メリット |
|------|------|---------|
| **ネイティブ統合** | Snowflake内で実行 | データの移動不要 |
| **Pythonのみで記述** | HTML/CSS/JS不要 | データ分析者でも作れる |
| **インタラクティブUI** | ドロップダウン・ボタン・フォーム | ユーザーが条件を変えながら分析できる |
| **セキュア** | Snowflakeの認証を利用 | 追加の認証設定不要 |
| **簡単な共有** | URLを共有するだけ | デプロイ作業不要 |

### 7.3 ユースケース

| ユースケース | 具体例 |
|-------------|--------|
| **データ入力アプリ** | マスタデータの編集画面 |
| **分析ダッシュボード** | ユーザーが条件を指定できる分析画面 |
| **ML予測アプリ** | パラメータを入力して予測結果を表示 |
| **データカタログ** | テーブル情報の検索・閲覧 |

### 7.4 簡単なコード例

```python
import streamlit as st
from snowflake.snowpark.context import get_active_session

# Snowflakeセッションを取得
session = get_active_session()

# タイトル
st.title("売上分析アプリ")

# ユーザー入力（ドロップダウン）
region = st.selectbox("地域を選択", ["APAC", "EMEA", "NA"])

# データ取得
query = f"SELECT * FROM sales WHERE region = '{region}'"
df = session.sql(query).to_pandas()

# 結果表示
st.dataframe(df)
st.bar_chart(df.set_index('product')['amount'])
```

---

## 8. 管理機能

### 8.1 Adminメニュー

管理者向けの設定・監視機能が集約されています。

| 項目 | 機能 | 誰が使うか |
|------|------|-----------|
| **Users & Roles** | ユーザー・ロールの作成・管理 | セキュリティ管理者 |
| **Warehouses** | Warehouse設定・状態監視 | システム管理者 |
| **Resource Monitors** | コスト監視・上限設定 | コスト管理者 |
| **Cost Management** | 使用量・コストの詳細確認 | 経営層、管理者 |
| **Security** | ネットワークポリシー等 | セキュリティ管理者 |

### 8.2 Activityメニュー

実行状況や履歴の確認ができます。

| 項目 | 内容 | 保持期間 |
|------|------|---------|
| **Query History** | クエリ実行履歴 | 14日間 |
| **Copy History** | COPY INTOの履歴 | 14日間 |
| **Task History** | Taskの実行履歴 | 14日間 |
| **Dynamic Table Refresh History** | Dynamic Tableの更新履歴 | 14日間 |

---

## 9. Snowflake Marketplace

### 9.1 Marketplaceとは

**サードパーティのデータやアプリを発見・取得**できるプラットフォームです。

> **実務での活用**
> 自社データだけでなく、天気データ、経済指標、人口統計など外部データと組み合わせることで、分析の幅が広がります。

### 9.2 提供されるもの

| 種類 | 説明 | 例 |
|------|------|-----|
| **Data Shares** | 直接アクセスできるデータ | 気象データ、POIデータ |
| **Data Services** | API経由のサービス | 住所正規化、翻訳 |
| **Native Apps** | Snowflake上で動くアプリ | データ品質ツール、可視化ツール |

### 9.3 検索フィルタ

Marketplaceでは以下のフィルタを使って目的のデータを絞り込めます：

| フィルタ | 説明 |
|---------|------|
| **Categories** | 業種・データの種類で絞り込み（金融、気象、人口統計など） |
| **Provider** | データ提供者（企業名）で絞り込み |
| **Price** | 価格帯で絞り込み（**無料のみ**、有料含む など） |

> **試験ポイント**: `Price（価格）フィルタ`で無料のデータのみを絞り込むことができます。

### 9.4 利用の流れ

```
1. Marketplaceでデータ/アプリを検索（カテゴリ・価格でフィルタ）
        ↓
2. 詳細を確認（プロバイダー、更新頻度、料金）
        ↓
3. 「Get」または「Request」でアクセス申請
        ↓
4. 承認後、自分のアカウントからアクセス可能に
```

---

## 10. 試験対策ポイント

### 必須暗記事項

- [ ] Snowsightの主要機能（Worksheets、Workspaces、Notebooks、Dashboard、Query History）
- [ ] オブジェクトブラウザの目的（データベースオブジェクトの表示・フィルタリング）
- [ ] テーブルプレビューは**最初の100行**のみ表示
- [ ] WorksheetsとWorkspacesの違い（Git連携、ファイルベース管理、同時クエリ実行）
- [ ] **ワークシートのコンテキスト**：Role/Warehouseは**必須**、Database/Schemaは**任意（ホームベース）**
- [ ] SHOW DATABASES / SHOW SCHEMAS / SHOW SCHEMAS IN ACCOUNT の違い
- [ ] NotebooksとWorksheetsの違い（対応言語、セル単位実行、ドキュメント性）
- [ ] Notebooksの変数参照構文: `{{変数名}}`（Jinjaスタイル）
- [ ] `LIMIT` のみで `ORDER BY` なしの場合、結果は**非決定的**（毎回同じ行が返るとは限らない）
- [ ] `TOP n` と `LIMIT n` は同じ意味
- [ ] データロードUIの利点（データ型の自動検出、レコードの直接挿入）
- [ ] Marketplaceの `Price` フィルタで無料データのみを絞り込める
- [ ] Query Profileで確認できる情報（Bytes Scanned、Partitions Scanned、Spillage）
- [ ] Streamlit in Snowflakeの特徴（ネイティブ統合、データ移動不要）
- [ ] ナビゲーション構造（Projects » Worksheets/Workspaces/Notebooks）

### "Does Not Exist" エラーのトラブルシューティング

Snowflakeでよく遭遇するエラーです。以下の順番でチェックしましょう。

```
エラー: Object 'TABLE_NAME' does not exist or not authorized.

確認順序:
1. 現在のロール（第1のルール）  → SELECT CURRENT_ROLE()
2. ワークシートのDatabaseコンテキスト → 正しいDBが設定されているか
3. ワークシートのSchemaコンテキスト  → 正しいSchemaが設定されているか
4. オブジェクト名のタイポ           → SHOW TABLES で実際の名前を確認
5. そもそも作成していない           → SHOW TABLES で一覧を確認
```

| 原因 | 対処法 |
|------|--------|
| ロールがオブジェクトにアクセスできない | ロールを切り替えるか、オーナーシップを移譲 |
| DBコンテキストが違うDBを向いている | ワークシートのDatabaseドロップダウンを変更 |
| Schemaコンテキストが違う | ワークシートのSchemaドロップダウンを変更 |
| オブジェクト名のタイポ | `ALTER SCHEMA 誤名 RENAME TO 正名;` |
| 間違ったDBに作成した | `ALTER SCHEMA 元のDB.名前 RENAME TO 正しいDB.名前;` |

### よく出る問題パターン

1. 「WorksheetsとNotebooksの違いは？」
2. 「WorkspacesとWorksheetsの違いは？」
3. 「Query Profileで確認できるのは？」
4. 「Warehouseが停止中でも使える機能は？」
5. 「Marketplaceで提供されるものは？」
6. 「LIMITのみでORDER BYなしの場合、結果はどうなるか？」
7. 「Notebooksで変数を参照する構文は？」

### 理解度確認

- WorksheetsとWorkspacesの違いを説明できる？
- ワークシートとNotebooksをそれぞれどんな場面で使うか説明できる？
- Query Profileを見て、クエリの問題点を特定できる？
- Streamlitでできることを説明できる？
- LIMITとORDER BYの関係を説明できる？
