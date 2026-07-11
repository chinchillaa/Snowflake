select raw_log, raw_log:agent::text, raw_log:ip_address::text as ip_address, raw_log:datetime_iso8601
from AGS_GAME_AUDIENCE.RAW.GAME_LOGS
where ip_address is null;

delete from AGS_GAME_AUDIENCE.RAW.GAME_LOGS
where raw_log:ip_address is null;

select *
from AGS_GAME_AUDIENCE.RAW.GAME_LOGS;
