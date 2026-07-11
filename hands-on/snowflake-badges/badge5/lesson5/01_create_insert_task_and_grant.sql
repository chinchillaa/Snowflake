-- LOAD_LOGS_ENHANCEDタスクを作成し、5分ごとにログデータを加工・挿入する
create or replace task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED
	warehouse=COMPUTE_WH
	schedule='5 minute'
	as
        INSERT INTO AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED 
        SELECT logs.ip_address 
        , logs.user_login as GAMER_NAME
        , logs.user_event as GAME_EVENT_NAME
        , logs.datetime_iso8601 as GAME_EVENT_UTC
        , city
        , region
        , country
        , timezone as GAMER_LTZ_NAME
        , CONVERT_TIMEZONE( 'UTC',timezone,logs.datetime_iso8601) as game_event_ltz
        , DAYNAME(game_event_ltz) as DOW_NAME
        , TOD_NAME
        from ags_game_audience.raw.LOGS logs
        JOIN ipinfo_geoloc.demo.location loc 
        ON ipinfo_geoloc.public.TO_JOIN_KEY(logs.ip_address) = loc.join_key
        AND ipinfo_geoloc.public.TO_INT(logs.ip_address) 
        BETWEEN start_ip_int AND end_ip_int
        JOIN ags_game_audience.raw.TIME_OF_DAY_LU tod
        ON HOUR(game_event_ltz) = tod.hour;

select count(*)
from ags_game_audience.enhanced.logs_enhanced;

use role accountadmin;
-- SYSADMINロールでタスクをテストするには、この権限付与が必要です
-- タスクのオーナーがSYSADMINであっても、この設定は必須です
grant execute task on account to role SYSADMIN;
grant usage on warehouse COMPUTE_WH to role SYSADMIN;

use role sysadmin; 

execute task ags_game_audience.raw.LOAD_LOGS_ENHANCED;

select count(*)
from ags_game_audience.enhanced.logs_enhanced;
