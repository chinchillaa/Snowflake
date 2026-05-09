---
name: optimize-sql-filenames
description: 指定ディレクトリ内の.sqlファイル名を、内容とレッスンの処理手順が明確になるよう連番付きの説明的な名前にリネームする。ファイル名を整理したい、分かりやすくしたい、処理順序を明確にしたい場合に使用する。
---

# SQLファイル名 最適化スキル

## 目的

指定されたディレクトリ（badge/lessonなど）内の `.sql` ファイルを読み込み、各ファイルの内容とレッスン上の処理順序を分析した上で、連番付きの説明的なファイル名にリネームする。

## いつ使うか

- SQLファイル名が曖昧で、内容や処理順序がファイル名から判断できない場合
- lesson内のSQLファイルを処理順に整理したい場合
- 複数レッスンのSQLファイルを一括で最適化したい場合

## 対象外

- `dora_*.sql` ファイル（DORA採点用スクリプト）はリネーム対象外とする
- `.sql` 以外のファイル（.md, .json など）はリネーム対象外とする

## 実行手順

### Step 1: 対象ファイルの特定

1. `ls -R <対象ディレクトリ>` で全ファイルを一覧する
2. 各lessonディレクトリ内の `.sql` ファイルを特定する（`dora_*.sql` は除外）
3. 既にリネーム済みのファイル（`NN_` 連番プレフィックス付き）がある場合はスキップする

### Step 2: ファイル内容の分析

各SQLファイルを読み込み、以下を特定する:

| 分析観点 | 確認内容 |
|---|---|
| **主要SQL操作** | CREATE, INSERT, MERGE, SELECT, ALTER, GRANT, TRUNCATE, DELETE など |
| **対象オブジェクト** | テーブル名、ビュー名、スキーマ名、タスク名など |
| **処理の目的** | データロード、変換、確認、権限設定、テストなど |
| **空ファイル** | 内容が空の場合はリネーム不要、旧名に参照コメントを残すだけ |

### Step 3: lesson.md による処理順序の決定

1. 対応する `lesson.md` を読み込む
2. lessonの説明順序に基づいて、各SQLファイルの実行順序を決定する
3. lesson.md がない場合は、SQL内容の論理的な依存関係（CREATE → INSERT → SELECT）から順序を推定する

### Step 4: 新しいファイル名の決定

#### 命名規則

```
NN_<動詞>_<対象>_<補足>.sql
```

- `NN`: 2桁の連番（`01`, `02`, ...）。処理順序を表す
- `<動詞>`: 主要操作を表す英語動詞（小文字スネークケース）
- `<対象>`: 操作対象のオブジェクト名や概念（小文字スネークケース）
- `<補足>`: 必要に応じて処理の特徴を追加（省略可）

#### 動詞の選択ガイド

| SQL操作 | 推奨動詞 |
|---|---|
| CREATE DATABASE / SCHEMA | `create_database`, `create_schema` |
| CREATE TABLE | `create_<テーブル名>_table` |
| CREATE VIEW | `create_<ビュー名>_view` |
| CREATE TASK | `create_<タスク名>_task` |
| INSERT / COPY INTO | `load_<対象>` |
| MERGE INTO | `merge_into_<対象>` |
| SELECT（確認用） | `check_<確認内容>`, `count_<対象>` |
| ALTER SESSION | `alter_session_<設定>` |
| GRANT | `grant_<権限>_<ロール>` |
| TRUNCATE | `truncate_<対象>` |
| DELETE | `delete_<条件>` |
| 複合操作 | 最も重要な操作を代表動詞とする |

#### ファイル名の例

| 内容 | ファイル名 |
|---|---|
| DB作成 + スキーマ作成 | `01_create_database_and_schema.sql` |
| ステージ確認 | `02_list_stage_files.sql` |
| ファイルフォーマット作成 + データロード | `03_create_file_format_and_load.sql` |
| MERGE文でタスク作成 + 実行 | `05_create_merge_task_and_execute.sql` |
| Time Travel復元 | `08_merge_update_and_time_travel.sql` |
| ゼロコピークローン | `09_zero_copy_clone_backup.sql` |

### Step 5: リネームの実行

この環境ではファイル削除ができないため、以下の手順で行う:

1. **新ファイルの作成**: `write` ツールで新しいファイル名に元の内容を書き出す
2. **旧ファイルの無効化**: `write` ツールで旧ファイルの内容をリネーム先への参照コメントに置き換える

旧ファイルに書き込む内容のフォーマット:

```sql
-- This file has been renamed to: <新ファイル名>
```

空ファイルの場合:

```sql
-- This file was empty and has been superseded. See <関連する新ファイル名>
```

### Step 6: 結果の確認と報告

1. `ls -R <対象ディレクトリ>` で最終的なファイル構造を確認する
2. 以下の形式で対応表を報告する:

```markdown
| Lesson | 新ファイル名 | 内容 |
|--------|-------------|------|
| **N** | `NN_xxx.sql` | 〜の処理 |
```

## 注意事項

- 元のSQLコードは一切変更しない（コメントも含め完全に保持する）
- `dora_*.sql` は絶対にリネームしない
- 連番は各lessonディレクトリ内で独立して `01` から振る
- 1つのファイルに複数の処理が含まれる場合は、最も重要な処理を代表名とする
- 既にリネーム済み（`NN_` プレフィックス付き）のファイルは再処理しない
- バッチ処理で複数ファイルの read/write を並列実行し、効率化する
