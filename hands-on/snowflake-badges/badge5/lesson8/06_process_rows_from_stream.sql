/*
  ストリーム（CDC）を使ったMERGE処理
  ED_CDC_STREAMに蓄積された未処理の変更行だけをLOGS_ENHANCEDにマージする。
  全行スキャンする旧タスクと異なり、新規追加分のみを効率的に処理できる。
  MERGEが成功するとストリームの行は自動的に消費（クリア）される。
*/

-- ストリームに溜まっている未処理の行数を確認する
select * 
from ags_game_audience.raw.ed_cdc_stream;

-- ストリームの行を使ってLOGS_ENHANCEDへMERGEする
merge into AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED e
USING (
        SELECT cdc.ip_address 
        , cdc.user_login as GAMER_NAME
        , cdc.user_event as GAME_EVENT_NAME
        , cdc.datetime_iso8601 as GAME_EVENT_UTC
        , city
        , region
        , country
        , timezone as GAMER_LTZ_NAME
        , CONVERT_TIMEZONE( 'UTC',timezone,cdc.datetime_iso8601) as game_event_ltz  -- UTCからローカルタイムゾーンに変換
        , DAYNAME(game_event_ltz) as DOW_NAME                                       -- 曜日名を導出
        , TOD_NAME
        from ags_game_audience.raw.ed_cdc_stream cdc                                -- ソースがテーブルではなくストリーム（未処理行のみ）
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
        , COUNTRY, GAMER_LTZ_NAME, GAME_EVENT_LTZ
        , DOW_NAME, TOD_NAME)
        VALUES
        (IP_ADDRESS, GAMER_NAME, GAME_EVENT_NAME
        , GAME_EVENT_UTC, CITY, REGION
        , COUNTRY, GAMER_LTZ_NAME, GAME_EVENT_LTZ
        , DOW_NAME, TOD_NAME);

-- MERGE成功後、ストリームの行が消費されたか確認する
-- （正常であれば0行になる。ストリームはDMLで消費されると自動的にクリアされる）
select * 
from ags_game_audience.raw.ed_cdc_stream; 
