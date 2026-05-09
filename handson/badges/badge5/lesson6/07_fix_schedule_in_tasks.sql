create or replace task AGS_GAME_AUDIENCE.RAW.GET_NEW_FILES
USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
schedule = '5 minute'
as copy into AGS_GAME_AUDIENCE.RAW.PL_GAME_LOGS
from @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE_PIPELINE
file_format = (format_name = AGS_GAME_AUDIENCE.RAW.FF_JSON_LOGS);

create
or replace task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED
USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'XSMALL'
after AGS_GAME_AUDIENCE.RAW.GET_NEW_FILES
as merge into ags_game_audience.enhanced.logs_enhanced e using (
    SELECT
        logs.ip_address,
        logs.user_login as GAMER_NAME,
        logs.user_event as GAME_EVENT_NAME,
        logs.datetime_iso8601 as GAME_EVENT_UTC,
        city,
        region,
        country,
        timezone as GAMER_LTZ_NAME,
        CONVERT_TIMEZONE('UTC', timezone, logs.datetime_iso8601) as game_event_ltz,
        DAYNAME(game_event_ltz) as DOW_NAME,
        TOD_NAME
    from
        ags_game_audience.raw.PL_LOGS logs
        JOIN ipinfo_geoloc.demo.location loc ON ipinfo_geoloc.public.TO_JOIN_KEY(logs.ip_address) = loc.join_key
        AND ipinfo_geoloc.public.TO_INT(logs.ip_address) BETWEEN start_ip_int
        AND end_ip_int
        JOIN ags_game_audience.raw.TIME_OF_DAY_LU tod ON HOUR(game_event_ltz) = tod.hour
) r on r.gamer_name = e.gamer_name
and r.game_event_utc = e.game_event_utc
and r.game_event_name = e.game_event_name
when not matched then
insert
    (
        IP_ADDRESS,
        GAMER_NAME,
        GAME_EVENT_NAME,
        GAME_EVENT_UTC,
        CITY,
        REGION,
        COUNTRY,
        GAMER_LTZ_NAME,
        GAME_EVENT_LTZ,
        DOW_NAME,
        TOD_NAME
    )
values(
        IP_ADDRESS,
        GAMER_NAME,
        GAME_EVENT_NAME,
        GAME_EVENT_UTC,
        CITY,
        REGION,
        COUNTRY,
        GAMER_LTZ_NAME,
        GAME_EVENT_LTZ,
        DOW_NAME,
        TOD_NAME
    );

-- タスクがサーバーレス（User Task Managed） で実行されるため、タスクのオーナーロール（SYSADMIN）に EXECUTE MANAGED TASK 権限が必要
GRANT EXECUTE MANAGED TASK ON ACCOUNT TO ROLE SYSADMIN;

-- 他のタスクに依存するタスクがある場合、トリガーとなるタスクよりも先に、依存するタスクを再開する必要がある。まずLOAD_LOGS_ENHANCEDを再開し、次にGET_NEW_FILESを再開。
alter task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED resume;
alter task AGS_GAME_AUDIENCE.RAW.GET_NEW_FILES resume;

select
    count(*)
from
    ags_game_audience.enhanced.logs_enhanced;

alter task AGS_GAME_AUDIENCE.RAW.GET_NEW_FILES suspend;
alter task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED suspend;
