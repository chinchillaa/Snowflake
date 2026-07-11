# Badge5 パイプライン全体図

## データベース構成

```
AGS_GAME_AUDIENCE
├── RAW (スキーマ)
│   ├── @UNI_KISHORE              ... 外部ステージ (初期データ)
│   ├── @UNI_KISHORE_PIPELINE     ... 外部ステージ (パイプライン用)
│   ├── FF_JSON_LOGS              ... ファイルフォーマット (JSON)
│   ├── GAME_LOGS                 ... テーブル (初期ロード用)
│   ├── PL_GAME_LOGS              ... テーブル (パイプライン用)
│   ├── LOGS                      ... ビュー (@UNI_KISHORE → 直接参照)
│   ├── PL_LOGS                   ... ビュー (PL_GAME_LOGS → JSON解析)
│   ├── TIME_OF_DAY_LU            ... テーブル (時間帯ルックアップ)
│   ├── GET_NEW_FILES             ... タスク (ルート, 5分間隔)
│   └── LOAD_LOGS_ENHANCED        ... タスク (依存, AFTER GET_NEW_FILES)
└── ENHANCED (スキーマ)
    └── LOGS_ENHANCED             ... テーブル (最終成果物)
```

## パイプラインフロー図

```
 ┌─────────────────────────────────────────────────────────────────────────┐
 │  TASK 1: GET_NEW_FILES  (5分間隔 / Serverless XSMALL)                  │
 │  ファイル: lesson6/02, lesson6/07                                       │
 ├─────────────────────────────────────────────────────────────────────────┤
 │                                                                         │
 │   ┌──────────────────────┐    COPY INTO    ┌──────────────────────┐    │
 │   │ STAGE                │ ──────────────→ │ TABLE                │    │
 │   │ @UNI_KISHORE_        │                 │ RAW.PL_GAME_LOGS     │    │
 │   │   PIPELINE           │                 │ (RAW_LOG VARIANT)    │    │
 │   │ (JSONログファイル)    │                 └──────────┬───────────┘    │
 │   └──────────────────────┘                            │                 │
 └───────────────────────────────────────────────────────┼─────────────────┘
                                                         │
                                              SELECT (JSON解析)
                                                         │
                                                         ▼
                                              ┌──────────────────────┐
                                              │ VIEW                 │
                                              │ RAW.PL_LOGS          │
                                              │ ・datetime_iso8601   │
                                              │ ・user_event         │
                                              │ ・user_login         │
                                              │ ・ip_address         │
                                              │ ファイル: lesson6/03 │
                                              └──────────┬───────────┘
                                                         │
 ┌───────────────────────────────────────────────────────┼─────────────────┐
 │  TASK 2: LOAD_LOGS_ENHANCED  (AFTER GET_NEW_FILES / Serverless XSMALL) │
 │  ファイル: lesson6/04, lesson6/07                                       │
 ├─────────────────────────────────────────────────────────────────────────┤
 │                                                                         │
 │   ┌──────────────────────┐                                              │
 │   │ 共有DB               │                                              │
 │   │ IPINFO_GEOLOC.DEMO   │──┐                                          │
 │   │   .LOCATION           │  │ JOIN (IP → 都市/国/TZ)                   │
 │   │ IPINFO_GEOLOC.PUBLIC  │  │ TO_JOIN_KEY() / TO_INT()                 │
 │   │   .TO_JOIN_KEY()      │  │                                          │
 │   │   .TO_INT()           │  │                                          │
 │   └──────────────────────┘  │                                           │
 │                              ▼                                          │
 │   RAW.PL_LOGS ─────────→ MERGE INTO ←──── RAW.TIME_OF_DAY_LU          │
 │                          (重複排除)         (hour → tod_name)           │
 │                              │              ファイル: lesson4/05        │
 │                              │                                          │
 │            ON: gamer_name + game_event_utc + game_event_name            │
 │            WHEN NOT MATCHED → INSERT                                    │
 │                              │                                          │
 │                              ▼                                          │
 │                   ┌─────────────────────────┐                           │
 │                   │ TABLE                    │                           │
 │                   │ ENHANCED.LOGS_ENHANCED   │                           │
 │                   │ ・IP_ADDRESS             │                           │
 │                   │ ・GAMER_NAME             │                           │
 │                   │ ・GAME_EVENT_NAME        │                           │
 │                   │ ・GAME_EVENT_UTC         │                           │
 │                   │ ・CITY / REGION / COUNTRY│ ← IPINFO JOIN           │
 │                   │ ・GAMER_LTZ_NAME         │ ← タイムゾーン          │
 │                   │ ・GAME_EVENT_LTZ         │ ← UTC→ローカル変換     │
 │                   │ ・DOW_NAME               │ ← 曜日                  │
 │                   │ ・TOD_NAME               │ ← TIME_OF_DAY_LU JOIN  │
 │                   │ ファイル: lesson4/04     │                           │
 │                   └─────────────────────────┘                           │
 └─────────────────────────────────────────────────────────────────────────┘
```

## タスク依存チェーン (最終形)

```
GET_NEW_FILES (5分間隔, ルートタスク)
     │
     │  AFTER (依存タスク)
     ▼
LOAD_LOGS_ENHANCED (GET_NEW_FILES 完了後に自動実行)
```

## ファイル × オブジェクト対応表

### Lesson 2: 初期セットアップ

| ファイル | 作成されるオブジェクト | 操作 |
|---|---|---|
| `lesson2/01_create_database_and_schema.sql` | DB: `AGS_GAME_AUDIENCE`, SCHEMA: `RAW` | CREATE DATABASE / SCHEMA |
| `lesson2/02_list_stage_files.sql` | - | LIST @UNI_KISHORE (確認のみ) |
| `lesson2/03_create_file_format_and_load.sql` | `FF_JSON_LOGS`, TABLE: `GAME_LOGS` | CREATE FILE FORMAT / COPY INTO |
| `lesson2/04_create_logs_view.sql` | VIEW: `RAW.LOGS` | CREATE VIEW (@UNI_KISHORE → 直接参照) |

### Lesson 3: データクレンジング

| ファイル | 操作対象 | 操作 |
|---|---|---|
| `lesson3/04_load_updated_feed.sql` | TABLE: `GAME_LOGS` | COPY INTO (updated_feed) |
| `lesson3/05_filter_and_delete_null_ip.sql` | TABLE: `GAME_LOGS` | DELETE (ip_address IS NULL) |

### Lesson 4: エンリッチメント

| ファイル | 作成されるオブジェクト | 操作 |
|---|---|---|
| `lesson4/03_create_enhanced_schema.sql` | SCHEMA: `ENHANCED` | CREATE SCHEMA |
| `lesson4/05_create_time_of_day_lookup.sql` | TABLE: `RAW.TIME_OF_DAY_LU` | CREATE TABLE / INSERT |
| `lesson4/04_create_logs_enhanced_table.sql` | TABLE: `ENHANCED.LOGS_ENHANCED` | CREATE TABLE AS SELECT |

### Lesson 5: タスク作成 (初期版)

| ファイル | 作成されるオブジェクト | 操作 |
|---|---|---|
| `lesson5/01_create_insert_task_and_grant.sql` | TASK: `LOAD_LOGS_ENHANCED` (INSERT版) | CREATE TASK (5分, INSERT INTO) |
| `lesson5/04_merge_into_logs_enhanced.sql` | - | MERGE INTO (手動実行テスト) |
| `lesson5/05_create_merge_task_and_execute.sql` | TASK: `LOAD_LOGS_ENHANCED` (MERGE版) | CREATE OR REPLACE TASK (MERGE INTO) |

### Lesson 6: 本番パイプライン (最終形)

| ファイル | 作成されるオブジェクト | 操作 |
|---|---|---|
| `lesson6/01_create_pl_game_logs_table.sql` | TABLE: `RAW.PL_GAME_LOGS` | CREATE TABLE / COPY INTO |
| `lesson6/02_create_copy_into_task.sql` | TASK: `GET_NEW_FILES` | CREATE TASK (COPY INTO) |
| `lesson6/03_create_pipeline_view.sql` | VIEW: `RAW.PL_LOGS` | CREATE VIEW (PL_GAME_LOGS → JSON解析) |
| `lesson6/04_fix_merge_task.sql` | TASK: `LOAD_LOGS_ENHANCED` (PL_LOGS版) | CREATE OR REPLACE TASK (ソースをPL_LOGSに変更) |
| `lesson6/05_resume_and_suspend_task.sql` | - | ALTER TASK RESUME / SUSPEND |
| `lesson6/06_data_lineage.sql` | - | データリネージ確認クエリ |
| `lesson6/07_fix_schedule_in_tasks.sql` | TASK: `GET_NEW_FILES`, `LOAD_LOGS_ENHANCED` | Serverless化 + AFTER依存に変更 |

## データリネージ (最終パイプライン)

```
@UNI_KISHORE_PIPELINE  →  PL_GAME_LOGS  →  PL_LOGS (VIEW)  →  LOGS_ENHANCED
(ステージ上のファイル)    (行数=files×10)   (同件数)           (≤同件数: IP不一致分減)
```

## タスクの進化 (Lesson 5 → 6 → 7)

| バージョン | ソース | 操作 | スケジュール | ウェアハウス |
|---|---|---|---|---|
| Lesson 5 初期 | `RAW.LOGS` (ステージ直参照) | INSERT INTO | 5分 | COMPUTE_WH |
| Lesson 5 改善 | `RAW.LOGS` | MERGE INTO | 5分 | COMPUTE_WH |
| Lesson 6 パイプライン | `RAW.PL_LOGS` (テーブル経由) | MERGE INTO | 5分 | COMPUTE_WH |
| Lesson 6 最終形 | `RAW.PL_LOGS` | MERGE INTO | AFTER GET_NEW_FILES | Serverless XSMALL |
