create or replace database social_media_floodgates;

create or replace table tweet_ingest(
    raw_status variant
);

create or replace file format nested_json_format
    TYPE = JSON
    NULL_IF = ()
	STRIP_OUTER_ARRAY = TRUE
    ;

copy into SOCIAL_MEDIA_FLOODGATES.PUBLIC.TWEET_INGEST
from @UTIL_DB.PUBLIC.MY_INTERNAL_STAGE/nutrition_tweets.json
file_format = (format_name = SOCIAL_MEDIA_FLOODGATES.PUBLIC.NESTED_JSON_FORMAT);