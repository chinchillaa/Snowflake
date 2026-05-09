select value
from SOCIAL_MEDIA_FLOODGATES.PUBLIC.TWEET_INGEST
, lateral flatten(input => raw_status:entities:urls);

select value
from SOCIAL_MEDIA_FLOODGATES.PUBLIC.TWEET_INGEST
,table(flatten(raw_status:entities:urls));

select value:text::varchar as hashtag_used
from tweet_ingest
, lateral flatten(
    input => raw_status:entities:hashtags
);

select raw_status:user:name::text as user_name
, raw_status:id as tweet_id
, value:text::varchar as hashtag_used
from tweet_ingest
, lateral flatten(
    input => raw_status:entities:hashtags
);