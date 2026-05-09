create or replace file format AGS_GAME_AUDIENCE.RAW.FF_JSON_LOGS
type = 'JSON'
strip_outer_array = true;

select $1
from @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE/kickoff
(file_format => AGS_GAME_AUDIENCE.RAW.FF_JSON_LOGS);

copy into AGS_GAME_AUDIENCE.RAW.GAME_LOGS
from @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE/updated_feed
file_format = (format_name = AGS_GAME_AUDIENCE.RAW.FF_JSON_LOGS);

select $1:agent::text as agent,
$1:datetime_iso8601::timestamp_ntz as datetime_iso8601,
$1:user_event::text as user_event,
$1:user_login::text as user_login,
$1 as row_log
from @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE/kickoff
(file_format => AGS_GAME_AUDIENCE.RAW.FF_JSON_LOGS);
