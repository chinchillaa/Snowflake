create
or replace task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED warehouse = COMPUTE_WH schedule = '5 minute' as merge into ags_game_audience.enhanced.logs_enhanced e using (
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
execute task ags_game_audience.raw.LOAD_LOGS_ENHANCED;
select
    count(*)
from
    ags_game_audience.enhanced.logs_enhanced;

execute task AGS_GAME_AUDIENCE.RAW.LOAD_LOGS_ENHANCED;