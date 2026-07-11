create or replace stream AGS_GAME_AUDIENCE.RAW.ed_cdc_stream
on table AGS_GAME_AUDIENCE.RAW.ED_PIPELINE_LOGS;

show streams;

select system$stream_has_data('AGS_GAME_AUDIENCE.RAW.ED_CDC_STREAM');