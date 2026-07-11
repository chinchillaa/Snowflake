/*
  CDC対応の新しいMERGEタスクを作成する
  旧タスク（LOAD_LOGS_ENHANCED）は毎回テーブル全行をスキャンしていたが、
  この新タスク（CDC_LOAD_LOGS_ENHANCED）はストリーム（ed_cdc_stream）から
  未処理の変更行だけを読み取るため、大幅に効率的。
  
  パイプライン全体の流れ:
    S3バケット → Snowpipe(PIPE_GET_NEW_FILES) → ED_PIPELINE_LOGS
    → ストリーム(ED_CDC_STREAM) → このタスク → LOGS_ENHANCED
*/

create or replace task AGS_GAME_AUDIENCE.RAW.CDC_LOAD_LOGS_ENHANCED
	USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE='XSMALL'                            -- サーバーレスコンピュート（ウェアハウス不要で効率的）
	SCHEDULE = '5 minutes'                                                       -- 5分ごとにストリームの未処理行をチェック
    when
        system$stream_has_data('AGS_GAME_AUDIENCE.RAW.ED_CDC_STREAM')            -- ストリーム依存関係ロジック
	as 
MERGE INTO AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED e
USING (
        SELECT cdc.ip_address 
        , cdc.user_login as GAMER_NAME
        , cdc.user_event as GAME_EVENT_NAME
        , cdc.datetime_iso8601 as GAME_EVENT_UTC
        , city
        , region
        , country
        , timezone as GAMER_LTZ_TIME
        , CONVERT_TIMEZONE( 'UTC',timezone,cdc.datetime_iso8601) as game_event_ltz  -- UTCからローカルタイムゾーンに変換
        , DAYNAME(game_event_ltz) as DOW_NAME                                       -- 曜日名を導出
        , TOD_NAME
        from ags_game_audience.raw.ed_cdc_stream cdc                                -- ストリームから未処理行のみ取得（CDC）
        JOIN ipinfo_geoloc.demo.location loc                                        -- IPアドレスから地理情報を取得
        ON ipinfo_geoloc.public.TO_JOIN_KEY(cdc.ip_address) = loc.join_key
        AND ipinfo_geoloc.public.TO_INT(cdc.ip_address) 
        BETWEEN start_ip_int AND end_ip_int
        JOIN AGS_GAME_AUDIENCE.RAW.TIME_OF_DAY_LU tod                               -- 時間帯ルックアップ（朝/昼/夜など）
        ON HOUR(game_event_ltz) = tod.hour
      ) r
ON r.GAMER_NAME = e.GAMER_NAME                                                     -- 同一プレイヤー・同一イベントの重複を防止
AND r.GAME_EVENT_UTC = e.GAME_EVENT_UTC
AND r.GAME_EVENT_NAME = e.GAME_EVENT_NAME 
WHEN NOT MATCHED THEN                                                               -- 未登録の行だけINSERT
INSERT (IP_ADDRESS, GAMER_NAME, GAME_EVENT_NAME
        , GAME_EVENT_UTC, CITY, REGION
        , COUNTRY, GAMER_LTZ_TIME, GAME_EVENT_LTZ
        , DOW_NAME, TOD_NAME)
        VALUES
        (IP_ADDRESS, GAMER_NAME, GAME_EVENT_NAME
        , GAME_EVENT_UTC, CITY, REGION
        , COUNTRY, GAMER_LTZ_TIME, GAME_EVENT_LTZ
        , DOW_NAME, TOD_NAME);
        
-- タスクを再開し、5分ごとの自動実行を開始する
-- （MERGE成功時にストリームの行は自動消費され、次回は新しい変更行のみ処理される）
alter task AGS_GAME_AUDIENCE.RAW.CDC_LOAD_LOGS_ENHANCED resume;
