# Lesson 7: デプロイして本番運用する

> **所要時間**: 20分  
> **形式**: Workspace から Snowflake オブジェクトへデプロイし、SQL で実行・スケジューリングする

---

## ゴール

このレッスンを終えると：
- `CREATE DBT PROJECT` でプロジェクトをデプロイできる
- `EXECUTE DBT PROJECT` で SQL からモデルを実行できる
- TASK でスケジュール実行を設定できる
- 実行ログを確認できる

---

## Step 1: デプロイ前の最終確認

> **やること**: 全モデルとテストが通ることを確認する。

```bash
dbt build --project-dir hands-on/dbt/dbt_learn
```

### 期待する結果

```
Done. PASS=N WARN=0 ERROR=0 SKIP=0
```

**ERROR が0であることが必須。** エラーがあればデプロイ前に修正する。

---

## Step 2: デプロイ先のスキーマを作成する

> **やること**: SQL Worksheet で実行する。

```sql
CREATE SCHEMA IF NOT EXISTS DBT_LEARN.DBT_PROJECTS;
```

---

## Step 3: CREATE DBT PROJECT を実行する

> **やること**: SQL Worksheet で実行する。

```sql
CREATE OR REPLACE DBT PROJECT DBT_LEARN.DBT_PROJECTS.LEARN_PROJECT
  FROM 'snow://workspace/USER$.PUBLIC."Snowflake"/versions/live/hands-on/dbt/dbt_learn';
```

### 確認

```sql
SHOW DBT PROJECTS IN SCHEMA DBT_LEARN.DBT_PROJECTS;
```

> `LEARN_PROJECT` が表示されれば成功！

```sql
DESCRIBE DBT PROJECT DBT_LEARN.DBT_PROJECTS.LEARN_PROJECT;
```

> プロジェクト内のファイル一覧が表示される。

---

## Step 4: EXECUTE DBT PROJECT で実行する

> **やること**: SQL Worksheet で以下を1つずつ実行する。

### 4-1: 全モデルを run

```sql
EXECUTE DBT PROJECT DBT_LEARN.DBT_PROJECTS.LEARN_PROJECT
  ARGS = 'run';
```

実行結果を確認。成功すれば `PASS=N` のサマリーが表示される。

### 4-2: テストを実行

```sql
EXECUTE DBT PROJECT DBT_LEARN.DBT_PROJECTS.LEARN_PROJECT
  ARGS = 'test';
```

### 4-3: 特定モデルだけ実行

```sql
EXECUTE DBT PROJECT DBT_LEARN.DBT_PROJECTS.LEARN_PROJECT
  ARGS = 'run --select fct_orders';
```

### 4-4: build（run + test を一括）

```sql
EXECUTE DBT PROJECT DBT_LEARN.DBT_PROJECTS.LEARN_PROJECT
  ARGS = 'build';
```

### 4-5: show でプレビュー（テーブルを作らない）

```sql
EXECUTE DBT PROJECT DBT_LEARN.DBT_PROJECTS.LEARN_PROJECT
  ARGS = 'show --select stg_orders --limit 5';
```

> **show** はテーブルを作成せずに結果だけ表示する。デバッグに便利。

---

## Step 5: 【実験】Workspace 実行 vs デプロイ実行の違いを確認

| 操作 | Workspace | デプロイ後 |
|------|-----------|-----------|
| 実行 | `dbt run --project-dir ...` | `EXECUTE DBT PROJECT ... ARGS = 'run'` |
| テスト | `dbt test --project-dir ...` | `EXECUTE DBT PROJECT ... ARGS = 'test'` |
| プレビュー | `dbt show --select ...` | `EXECUTE ... ARGS = 'show --select ...'` |
| スケジュール | 不可 | TASK で可能 |

> **核心**: デプロイすると **SQL だけで全操作が可能** になる。  
> Workspace を開かなくてもパイプラインを運用できる。

---

## Step 6: TASK でスケジュール実行する

> **やること**: SQL Worksheet で実行する。

```sql
CREATE OR REPLACE TASK DBT_LEARN.DBT_PROJECTS.DAILY_DBT_BUILD
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = 'USING CRON 0 6 * * * UTC'
AS
  EXECUTE DBT PROJECT DBT_LEARN.DBT_PROJECTS.LEARN_PROJECT
    ARGS = 'build';
```

### TASK を有効化する

作成直後の TASK はサスペンド状態。有効化が必要：

```sql
ALTER TASK DBT_LEARN.DBT_PROJECTS.DAILY_DBT_BUILD RESUME;
```

### 確認

```sql
SHOW TASKS IN SCHEMA DBT_LEARN.DBT_PROJECTS;
```

`state` が `started` になっていれば有効。

### CRON 式チートシート

| CRON | 意味 |
|------|------|
| `0 6 * * * UTC` | 毎日 6:00 UTC |
| `0 */4 * * * UTC` | 4時間ごと |
| `0 9 * * MON-FRI UTC` | 平日の 9:00 UTC |
| `30 22 * * * Asia/Tokyo` | 毎日 22:30 JST |

---

## Step 7: TASK を手動で実行してみる

スケジュールを待たずに手動実行：

```sql
EXECUTE TASK DBT_LEARN.DBT_PROJECTS.DAILY_DBT_BUILD;
```

---

## Step 8: 実行ログを確認する

```sql
SELECT *
FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY(
    TASK_NAME => 'DAILY_DBT_BUILD',
    SCHEDULED_TIME_RANGE_START => DATEADD(HOUR, -24, CURRENT_TIMESTAMP())
))
ORDER BY SCHEDULED_TIME DESC;
```

---

## Step 9: プロジェクトを更新する

Workspace でコードを変更した後、デプロイ済みプロジェクトを更新するには：

```sql
CREATE OR REPLACE DBT PROJECT DBT_LEARN.DBT_PROJECTS.LEARN_PROJECT
  FROM 'snow://workspace/USER$.PUBLIC."Snowflake"/versions/live/hands-on/dbt/dbt_learn';
```

> 上書きデプロイ。TASK はそのままで、次回実行時に新しいコードが使われる。

---

## Step 10: 片付け（任意）

学習が終わったら不要なリソースを削除：

```sql
-- TASK を停止・削除
ALTER TASK DBT_LEARN.DBT_PROJECTS.DAILY_DBT_BUILD SUSPEND;
DROP TASK IF EXISTS DBT_LEARN.DBT_PROJECTS.DAILY_DBT_BUILD;

-- dbt プロジェクトを削除
DROP DBT PROJECT IF EXISTS DBT_LEARN.DBT_PROJECTS.LEARN_PROJECT;

-- スキーマごと削除する場合
-- DROP SCHEMA IF EXISTS DBT_LEARN.DBT_PROJECTS;
-- DROP SCHEMA IF EXISTS DBT_LEARN.ANALYTICS;
-- DROP DATABASE IF EXISTS DBT_LEARN;
```

---

## 確認クイズ

1. `CREATE DBT PROJECT` の `FROM` には何を指定する？
2. `EXECUTE DBT PROJECT ... ARGS = 'show --select model'` は何をする？
3. TASK を作った直後に実行されない理由は？
4. Workspace でコードを修正した後、デプロイ済みプロジェクトに反映するには？

<details>
<summary>答えを見る</summary>

1. Workspace 内のプロジェクトへの `snow://` パス
2. モデルの出力結果をプレビュー表示する（テーブル/ビューは作成しない）
3. TASK は作成直後は SUSPEND 状態。`ALTER TASK ... RESUME` が必要
4. `CREATE OR REPLACE DBT PROJECT ...` で再デプロイする

</details>

---

## このレッスンで作ったもの

- [x] `CREATE DBT PROJECT` でデプロイ完了
- [x] `EXECUTE DBT PROJECT` で SQL 経由実行を確認
- [x] TASK でスケジュール設定（CRON）
- [x] 手動実行とログ確認

---

## 講座完了！全体のまとめ

```
Lesson 1: dbt とは何か（問題提起 → 解決策の理解）
    ↓
Lesson 2: 環境セットアップ（プロジェクト骨格作成）
    ↓
Lesson 3: 最初のモデル（source → staging → marts）
    ↓
Lesson 4: マテリアライゼーション（view / table / incremental）
    ↓
Lesson 5: テスト（品質を自動で担保する仕組み）
    ↓
Lesson 6: Jinja とマクロ（DRY 原則・動的 SQL）
    ↓
Lesson 7: デプロイ（本番運用へ）
```

### 身についたスキル

| スキル | 使える場面 |
|--------|-----------|
| staging / marts 設計 | あらゆる dbt プロジェクトの設計 |
| ref() / source() | モデル間の依存管理 |
| テスト定義 | データ品質の自動監視 |
| Jinja / マクロ | 繰り返しコードの排除 |
| CREATE / EXECUTE DBT PROJECT | Snowflake ネイティブ運用 |
| TASK | 定期実行の自動化 |

---

## 次のステップ（自主学習）

| テーマ | 内容 |
|--------|------|
| Snapshot | Type-2 SCD（緩やかに変化するディメンション）の実装 |
| Dynamic Table | Snowflake ネイティブの自動リフレッシュマテリアライゼーション |
| dbt_expectations | コミュニティパッケージによる高度なテスト |
| Semantic View | Cortex Analyst 連携のセマンティックレイヤー構築 |
| Multi-target | dev / staging / prod の環境分離 |
