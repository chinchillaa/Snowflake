-- CTAS で ED_PIPELINE_LOGS テーブルを作成（テーブル作成とデータロードを同時に行う）
create or replace table AGS_GAME_AUDIENCE.RAW.ED_PIPELINE_LOGS as
select
    metadata$filename as log_file_name,
    metadata$file_row_number as log_file_row_id,
    current_timestamp(0) as load_ltz,
    get($1, 'datetime_iso8601')::timestamp_ntz as datetime_iso8601,
    get($1, 'user_event')::text as user_event,
    get($1, 'user_login')::text as user_login,
    get($1, 'ip_address')::text as ip_address
from @AGS_GAME_AUDIENCE.RAW.UNI_KISHORE_PIPELINE
(file_format => AGS_GAME_AUDIENCE.RAW.FF_JSON_LOGS);

-- CTAS で作られた VARCHAR のサイズを確認する（大きすぎるはず）
describe table AGS_GAME_AUDIENCE.RAW.ED_PIPELINE_LOGS;

-- CTAS で作られた VARCHAR が大きすぎるので、適切なサイズに再定義する
create or replace table AGS_GAME_AUDIENCE.RAW.ED_PIPELINE_LOGS (
    LOG_FILE_NAME   VARCHAR(100),
    LOG_FILE_ROW_ID NUMBER,
    LOAD_LTZ        TIMESTAMP_LTZ,
    DATETIME_ISO8601 TIMESTAMP_NTZ,
    USER_EVENT      VARCHAR(25),
    USER_LOGIN      VARCHAR(100),
    IP_ADDRESS      VARCHAR(100)
);
