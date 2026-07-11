list @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE;

select
$1:datetime_iso8601::
from @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE/updated_feed
(file_format => AGS_GAME_AUDIENCE.RAW.FF_JSON_LOGS)
;

copy into AGS_GAME_AUDIENCE.RAW.GAME_LOGS
from @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE/updated_feed
file_format = (format_name = AGS_GAME_AUDIENCE.RAW.FF_JSON_LOGS);

select raw_log, raw_log:agent::text, raw_log:ip_address::text, raw_log:datetime_iso8601
from AGS_GAME_AUDIENCE.RAW.GAME_LOGS;

