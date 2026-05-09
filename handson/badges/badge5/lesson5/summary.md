# Lesson 5 サマリー — パイプラインのプロダクション化

## 学習目標

- データロードの歴史的手法（Trunc & Reload、クローニング）とその問題点を理解する
- **MERGE文** の仕組みと Update Merge / Insert Merge の使い分けを理解する
- **べき等性**（IDEMPOTENCY）の概念を理解し、べき等なパイプラインを構築できる
- Snowflakeの**タスク**（Task）を使ってETL処理を自動化できる
- **ゼロコピークローニング**と**タイムトラベル**を使ったデータ復旧方法を理解する

---

## 学んだこと

### プロダクション化とは

手動で1回だけ行ったETL処理を、自動的に繰り返し実行できるようにすることを**プロダクション化**（Productionizing）と呼びます。

> **なぜプロダクション化が必要なのか:** データエンジニアの仕事の本質は、データの流れを「一度きりの作業」から「持続的なパイプライン」に変えることです。手動でSQLを実行するのは開発・テスト段階であり、本番運用では自動化が不可欠です。

### データロード手法の進化

| 時代 | 手法 | 方法 | 問題点 |
|---|---|---|---|
| 2000年代 | **Trunc & Reload** | テーブルを空にして全行を再ロード | 毎回全データを処理、非効率 |
| 2000年代 | **Copy/Paste Cloning** | データベースを丸ごと複製して置換 | 時間とストレージの浪費 |
| 2010年代〜 | **MERGE** | 差分のみを検出して挿入・更新 | モダンで効率的 |

> **なぜTrunc & Reloadは今でも使われることがあるのか:** 単純で理解しやすく、確実に最新状態になるという利点があります。データ量が少ない場合や、全データの整合性が最重要な場合は、依然として有効な選択肢です。ただし、データ量が増えるとパフォーマンスが大幅に低下します。

### ゼロコピークローニング（Zero-Copy Cloning）

```sql
CREATE TABLE AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED_BU
CLONE AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;
```

| 特性 | 従来のクローニング | Snowflakeのゼロコピークローニング |
|---|---|---|
| ストレージ消費 | 元テーブルと同量 | 変更分のみ |
| 所要時間 | データ量に比例 | ほぼ一瞬 |
| コスト | 高い | 非常に低い |
| 用途 | バックアップ | テスト環境、バックアップ、開発環境 |

> **なぜ「ゼロコピー」と呼ばれるのか:** Snowflakeのクローンは元データのメタデータ（ポインタ）を共有します。実際のデータファイルがコピーされるわけではないため、「ゼロコピー」です。クローン先でデータが変更された場合にのみ、変更された部分の新しいストレージが使用されます。

### MERGE文の2つの使い方

#### Update Merge（既存行の更新）

```sql
MERGE INTO ENHANCED.LOGS_ENHANCED e
USING RAW.LOGS r
ON r.user_login = e.GAMER_NAME
AND r.datetime_iso8601 = e.GAME_EVENT_UTC
AND r.user_event = e.GAME_EVENT_NAME
WHEN MATCHED THEN
UPDATE SET ...;
```

#### Insert Merge（新規行の挿入）

```sql
MERGE INTO ENHANCED.LOGS_ENHANCED e
USING (...) r
ON r.user_login = e.GAMER_NAME
AND r.datetime_iso8601 = e.game_event_utc
AND r.user_event = e.game_event_name
WHEN NOT MATCHED THEN
INSERT (...) VALUES (...);
```

| 種類 | WHEN句 | 動作 | ユースケース |
|---|---|---|---|
| **Update Merge** | WHEN MATCHED | 既存行を更新 | データの修正・上書き |
| **Insert Merge** | WHEN NOT MATCHED | 新規行のみ挿入 | 差分ロード（重複防止） |

> **なぜON句に複数カラムが必要なのか:** ゲーマー名だけでは一意にレコードを特定できません。同じゲーマーにログイン行とログオフ行が存在するためです。ゲーマー名 + 日時 + イベント名の3つを組み合わせることで、各レコードを一意に識別できます。一意性の条件が不十分だとMERGEがエラーを返します。

### データ復旧の3つの方法

誤ったMERGEでデータが壊れた場合の修復方法：

1. **Trunc & Reload** — テーブルを空にして全データを再ロード
2. **クローンテーブルのスワップ** — 事前に作成したバックアップと入れ替え
3. **タイムトラベル** — テーブルを過去の任意の時点の状態に戻す

```sql
ALTER TABLE <壊れたテーブル> RENAME TO <一時名>;
ALTER TABLE <バックアップテーブル> RENAME TO <元の名前>;
```

> **なぜバックアップを事前に作るのか:** タイムトラベルには保持期間（デフォルト1日、最大90日）の制限があります。一方、クローンによるバックアップは明示的に削除しない限り存在し続けます。リスクの高い操作（MERGE、大量UPDATE）の前にクローンを作成しておくのはベストプラクティスです。

### べき等性（IDEMPOTENCY）

**べき等** とは「同じ操作を何回実行しても結果が同じ」という性質です。

| 操作 | べき等か | 理由 |
|---|---|---|
| 単純なINSERT | いいえ | 実行するたびに重複行が増える |
| INSERT MERGE | はい | NOT MATCHEDの行のみ挿入される |
| Trunc & Reload | はい | 毎回全データをリセットして再ロード |

> **なぜべき等性がパイプラインで重要なのか:** 自動化されたタスクは、ネットワーク障害やタイムアウトなどで予期せず再実行される可能性があります。べき等でないパイプラインは再実行のたびに重複データを生み出し、データ品質を損ないます。Insert MERGEを使えば、何回実行しても各レコードは1回だけロードされます。

### Snowflakeタスク（Task）

Snowflakeの**タスク**はSQL文をスケジュール実行する機能です。

```sql
CREATE OR REPLACE TASK AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED
    WAREHOUSE = 'COMPUTE_WH'
    SCHEDULE = '5 minute'
AS
    -- MERGE INSERT文がここに入る
;
```

| 操作 | コマンド | 説明 |
|---|---|---|
| 手動実行 | `EXECUTE TASK <名前>` | テスト用に即時実行 |
| スケジュール開始 | `ALTER TASK <名前> RESUME` | スケジュールを有効化 |
| スケジュール停止 | `ALTER TASK <名前> SUSPEND` | スケジュールを無効化 |
| タスク一覧 | `SHOW TASKS IN ACCOUNT` | アカウント内のタスク一覧 |
| 詳細確認 | `DESCRIBE TASK <名前>` | タスクの定義を確認 |

> **なぜSYSADMINにEXECUTE TASK権限が必要なのか:** タスクの実行はアカウントレベルの操作です。タスクを**所有**していることと、タスクを**実行**する権限は別物です。ACCOUNTADMINが `GRANT EXECUTE TASK ON ACCOUNT TO ROLE SYSADMIN` を実行しないと、SYSADMINはタスクの手動実行もスケジュール実行もできません。

### タスク構築の段階的アプローチ

最終的なタスクは以下のように「入れ子」になっています：

```
TASK（スケジュール実行）
    └── MERGE（差分検出）
        └── SELECT（データ変換：結合 + タイムゾーン変換 + 関数適用）
```

> **なぜ段階的に構築するのか:** 「象の食べ方は一口ずつ」です。最初にSELECTを書いてテスト → MERGEでラップしてテスト → TASKでラップしてテスト、と段階的に構築することで、各レイヤーのエラーを独立して検出・修正できます。最初から完全なコードを書こうとすると、エラーの原因特定が難しくなります。

### よくある問題と対処法

| 問題 | 原因 | 対処法 |
|---|---|---|
| 「Does not exist」エラー | ビューの所有者がACCOUNTADMIN | ビューの所有権をSYSADMINに移譲 |
| タスクが行を追加しない | SELECTだけでINSERTがない | SELECTの上にINSERT INTO文を追加 |
| 重複行が増え続ける | 単純INSERTを使用 | Insert MERGEに変更 |
| MERGEで重複エラー | ON句の条件が不十分 | datetime + event_nameを追加 |

---

## 🤖 DORAチェック — DNGW04

```sql
SELECT GRADER(step, (actual = expected), actual, expected, description) AS graded_results
FROM (
    SELECT
        'DNGW04' AS step,
        (SELECT COUNT(*) / IFF(COUNT(*) = 0, 1, COUNT(*))
         FROM TABLE(AGS_GAME_AUDIENCE.INFORMATION_SCHEMA.TASK_HISTORY(
             task_name => 'LOAD_LOGS_ENHANCED'
         ))) AS actual,
        1 AS expected,
        'Task exists and has been run at least once' AS description
);
```

> **このチェックが確認していること:** TASK_HISTORY関数でタスクの実行履歴を照会し、COUNT(*) / COUNT(*) = 1 となることを検証しています。履歴が1件以上あればこの式は1を返し、タスクが存在し最低1回実行されたことが確認できます。IFF(COUNT(*)=0, 1, COUNT(*)) はゼロ除算を防ぐための安全装置です。

---

## ✅ 完了チェックリスト

- [ ] **LOGS_ENHANCED** テーブルにすべての行が正しくロードされている（重複なし）
- [ ] **LOAD_LOGS_ENHANCED** タスクが存在し、Insert MERGE ロジックを含んでいる
- [ ] タスクを複数回実行しても行数が変わらない（べき等性の確認）
- [ ] SYSADMINにEXECUTE TASK権限が付与されている
- [ ] DNGW04のDORAチェックがグリーンチェック ✅ を返す
