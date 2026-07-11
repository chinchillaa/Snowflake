create or replace view AGS_GAME_AUDIENCE.RAW.logs as (
select $1:agent::text as agent,
$1:datetime_iso8601::timestamp_ntz as datetime_iso8601,
$1:user_event::text as user_event,
$1:user_login::text as user_login,
$1 as raw_log
from @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE/kickoff
(file_format => AGS_GAME_AUDIENCE.RAW.FF_JSON_LOGS)
);

create or replace view AGS_GAME_AUDIENCE.RAW.logs as (
select
$1:datetime_iso8601::timestamp_ntz as datetime_iso8601,
$1:user_event::text as user_event,
$1:user_login::text as user_login,
$1:ip_address::text as ip_address,
$1 as raw_log
from @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE
(file_format => AGS_GAME_AUDIENCE.RAW.FF_JSON_LOGS)
where ip_address is not null
);
