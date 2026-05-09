use role sysadmin;
create or replace database MELS_SMOOTHIE_CHALLENGE_DB;

drop schema public;

create or replace schema trails;

create or replace stage trails_geojson;
create or replace stage ZENAS_ATHLEISURE_DBtrails_parquet;