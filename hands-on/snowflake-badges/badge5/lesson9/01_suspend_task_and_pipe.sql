-- ============================================================
-- 稼働中のタスク・パイプをすべて一時停止する
-- ============================================================
-- クレジットの浪費を防ぐため、作業を中断する際は
-- 必ずタスクとパイプを一時停止してください。
-- 再開するときは RESUME / SET PIPE_EXECUTION_PAUSED=FALSE で戻せます。
-- ============================================================

-- タスク: CDC_LOAD_LOGS_ENHANCED（現在 started）
-- ストリーム+MERGEで5分ごとにLOGS_ENHANCEDを更新するタスク
ALTER TASK AGS_GAME_AUDIENCE.RAW.CDC_LOAD_LOGS_ENHANCED SUSPEND;

-- タスク: LOAD_LOGS_ENHANCED（現在 suspended → 念のため明示的に停止）
-- 旧パイプライン用のMERGEタスク（CDC版に置き換え済み）
ALTER TASK AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED SUSPEND;

-- タスク: GET_NEW_FILES（現在 suspended → 念のため明示的に停止）
-- 旧パイプライン用のCOPY INTOタスク（Snowpipeに置き換え済み）
ALTER TASK AGS_GAME_AUDIENCE.RAW.GET_NEW_FILES SUSPEND;

-- パイプ: PIPE_GET_NEW_FILES（現在稼働中）
-- S3バケットからED_PIPELINE_LOGSへ自動ロードするSnowpipe
ALTER PIPE AGS_GAME_AUDIENCE.RAW.PIPE_GET_NEW_FILES SET PIPE_EXECUTION_PAUSED = TRUE;

-- ============================================================
-- 停止確認
-- ============================================================

-- タスクの状態を確認（すべて suspended であればOK）
SHOW TASKS IN DATABASE AGS_GAME_AUDIENCE;

-- パイプの状態を確認（executionState が PAUSED であればOK）
SELECT PARSE_JSON(SYSTEM$PIPE_STATUS('AGS_GAME_AUDIENCE.RAW.PIPE_GET_NEW_FILES'));