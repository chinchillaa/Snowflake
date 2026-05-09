-- ============================================================
-- 🎯 LOAD_LOGS_ENHANCED タスクの更新
-- ============================================================
--
-- 【背景】
-- これまでのパイプラインは「時間駆動」で、2つのタスクがDAGを構成していた:
--   GET_NEW_FILES（ルート）→ LOAD_LOGS_ENHANCED（依存タスク）
--
-- レッスン8でSnowpipe（PIPE_GET_NEW_FILES）を導入したことで、
-- GET_NEW_FILESタスクは不要になった。
--
-- 【変更点】
-- 1. データソース: PL_LOGS（ビュー） → ED_PIPELINE_LOGS（テーブル）
--    - Snowpipeが直接 ED_PIPELINE_LOGS にデータをロードするため
-- 2. トリガー方式: after GET_NEW_FILES → SCHEDULE='5 Minutes'
--    - ルートタスクが無くなったので、独立したスケジュール実行に変更
-- 3. 宛先テーブル: LOGS_ENHANCED は変更なし
-- ============================================================

-- ステップ1: LOGS_ENHANCEDをTRUNCATEし、新パイプラインの結果だけを確認できるようにする
-- （念のためバックアップを作成してからTRUNCATE）
CREATE TABLE IF NOT EXISTS AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED_BACKUP
  CLONE AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;

TRUNCATE TABLE AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;

-- ステップ2: 既存タスクを一時停止する（実行中のタスクは編集できないため）
ALTER TASK AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED SUSPEND;

-- ステップ3: タスクを再作成する
-- 変更箇所は2つ:
--   (A) 'after GET_NEW_FILES' → SCHEDULE='5 Minutes'（独立スケジュール実行）
--   (B) FROM句: PL_LOGS → ED_PIPELINE_LOGS（Snowpipeのロード先テーブル）
CREATE OR REPLACE TASK AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED
    USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
    SCHEDULE = '5 Minutes'                                -- (A) 変更前: after AGS_GAME_AUDIENCE.RAW.GET_NEW_FILES → ルートタスク廃止のため独立スケジュールに変更
AS
MERGE INTO AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED e
USING (
    SELECT
        logs.IP_ADDRESS,
        logs.USER_LOGIN  AS GAMER_NAME,
        logs.USER_EVENT  AS GAME_EVENT_NAME,
        logs.DATETIME_ISO8601 AS GAME_EVENT_UTC,
        loc.CITY,
        loc.REGION,
        loc.COUNTRY,
        loc.TIMEZONE     AS GAMER_LTZ_NAME,
        CONVERT_TIMEZONE('UTC', loc.TIMEZONE, logs.DATETIME_ISO8601) AS GAME_EVENT_LTZ,
        DAYNAME(GAME_EVENT_LTZ) AS DOW_NAME,
        tod.TOD_NAME
    FROM AGS_GAME_AUDIENCE.RAW.ED_PIPELINE_LOGS logs       -- (B) 変更前: PL_LOGS（ビュー） → Snowpipeのロード先テーブルに変更
    JOIN IPINFO_GEOLOC.DEMO.LOCATION loc
      ON IPINFO_GEOLOC.PUBLIC.TO_JOIN_KEY(logs.IP_ADDRESS) = loc.JOIN_KEY
     AND IPINFO_GEOLOC.PUBLIC.TO_INT(logs.IP_ADDRESS) BETWEEN loc.START_IP_INT AND loc.END_IP_INT
    JOIN AGS_GAME_AUDIENCE.RAW.TIME_OF_DAY_LU tod
      ON HOUR(GAME_EVENT_LTZ) = tod.HOUR
) r
ON  r.GAMER_NAME      = e.GAMER_NAME
AND r.GAME_EVENT_UTC   = e.GAME_EVENT_UTC
AND r.GAME_EVENT_NAME  = e.GAME_EVENT_NAME
WHEN NOT MATCHED THEN INSERT (
    IP_ADDRESS, GAMER_NAME, GAME_EVENT_NAME, GAME_EVENT_UTC,
    CITY, REGION, COUNTRY, GAMER_LTZ_NAME,
    GAME_EVENT_LTZ, DOW_NAME, TOD_NAME
) VALUES (
    r.IP_ADDRESS, r.GAMER_NAME, r.GAME_EVENT_NAME, r.GAME_EVENT_UTC,
    r.CITY, r.REGION, r.COUNTRY, r.GAMER_LTZ_NAME,
    r.GAME_EVENT_LTZ, r.DOW_NAME, r.TOD_NAME
);

-- ステップ4: タスクを再開する
-- ※ Snowpipe（PIPE_GET_NEW_FILES）がED_PIPELINE_LOGSにデータを入れ、
--    このタスクが5分ごとにそのデータをLOGS_ENHANCEDへMERGEする
ALTER TASK AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED RESUME;

-- ============================================================
-- 確認用クエリ
-- ============================================================

-- タスクの状態を確認（STATEが'started'になっていればOK）
SHOW TASKS LIKE 'LOAD_LOGS_ENHANCED' IN SCHEMA AGS_GAME_AUDIENCE.RAW;

-- Snowpipeの状態も確認（パイプが動いているか）
SELECT PARSE_JSON(SYSTEM$PIPE_STATUS('AGS_GAME_AUDIENCE.RAW.PIPE_GET_NEW_FILES'));

-- しばらく待ってからLOGS_ENHANCEDの行数を確認
-- （Snowpipeがファイルをロードし、タスクがMERGEを実行した後に行が増える）
SELECT COUNT(*) FROM AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED;
