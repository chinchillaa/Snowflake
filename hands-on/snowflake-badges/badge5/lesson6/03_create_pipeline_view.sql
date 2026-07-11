create or replace view AGS_GAME_AUDIENCE.RAW.PL_LOGS(
	DATETIME_ISO8601,
	USER_EVENT,
	USER_LOGIN,
	IP_ADDRESS,
	RAW_LOG
) as (
select
$1:datetime_iso8601::timestamp_ntz as datetime_iso8601,
$1:user_event::text as user_event,
$1:user_login::text as user_login,
$1:ip_address::text as ip_address,
$1 as raw_log
from AGS_GAME_AUDIENCE.RAW.PL_GAME_LOGS
);