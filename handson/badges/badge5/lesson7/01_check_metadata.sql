select
    metadata$filename as log_file_name,
    metadata$file_row_number as log_file_row_id,
    current_timestamp(0) as load_ltz,
    get($1, 'datetime_iso8601')::timestamp_ntz as datetime_iso8601,
    get($1, 'user_event')::text as user_event,
    get($1, 'user_login')::text as user_login,
    get($1, 'ip_address')::text as ip_address,
from @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE_PIPELINE
(file_format => AGS_GAME_AUDIENCE.RAW.FF_JSON_LOGS);