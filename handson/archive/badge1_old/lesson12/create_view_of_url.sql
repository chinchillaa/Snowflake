create or replace view social_media_floodgates.public.urls_normalized as
(select raw_status:user:name::text as user_name
,raw_status:id as tweet_id
,value:display_url::text as url_used
from tweet_ingest
,lateral flatten
(input => raw_status:entities:urls)
);

create or replace view social_media_floodgates.public.hashtags_normalized as
(select raw_status:user:name::text as user_name
,raw_status:id as tweet_id
,value:text::text as hashtag_used
from tweet_ingest
,lateral flatten
(input => raw_status:entities:hashtags)
);