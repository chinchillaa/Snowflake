# SnowPro Associate 検証SQL

SnowPro Associate（SOL-C01）の学習まとめ（`ChinchillaVault/01_資格/certifications/snowpro-associate/notes/exam-summary/`）の各見出しに対応した、Snowflake UIで実際に実行して確認できる検証SQLファイル集です。

## ディレクトリ構成

| ディレクトリ | 対応まとめファイル | 内容 |
|------------|-----------------|------|
| `01_architecture/` | 01_アーキテクチャ基礎.md | Warehouse操作、オブジェクト階層、キャッシュ、クラスタリング |
| `02_ui_notebooks/` | 02_UI_Notebooks.md | SHOWコマンド、LIMIT/TOP、クエリ履歴 |
| `03_data_load/` | 03_データ管理_ロード.md | ステージ、ファイルフォーマット、COPY INTO、MERGE、タスク、ストリーム等 |
| `04_account_security/` | 04_アカウント_セキュリティ.md | アカウント情報、ネットワークポリシー、監査、パラメータ等 |
| `05_access_control/` | 05_アクセス制御_ロール.md | ロール管理、権限、マスキング、行アクセスポリシー等 |
| `06_cortex_ai_ml/` | 06_Cortex_AI_ML.md | COMPLETE、SUMMARIZE、SENTIMENT、EMBED_TEXT等 |
| `07_data_protection/` | 07_データ保護_共有.md | Time Travel、Zero-Copy Clone、データ共有 |
| `08_data_types/` | 08_データ型_SQL基礎.md | 各データ型、集約/ウィンドウ関数、FLATTEN、UDF、地理空間等 |
| `09_advanced_objects/` | 09_高度なオブジェクト_データレイク.md | 外部テーブル、マテリアライズドビュー、外部ボリューム、Iceberg |

## 使い方

1. Snowflake Worksheets または Workspaces を開く
2. 対応するSQLファイルを開いてコピーする
3. 必要に応じてデータベース名・スキーマ名等を自環境に合わせて修正する
4. セルごと（または `-- STEP` コメント単位）に実行して動作を確認する

## 作業進捗

→ [`PROGRESS.md`](./PROGRESS.md) を参照
