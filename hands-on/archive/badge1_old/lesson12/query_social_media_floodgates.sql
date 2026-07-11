select raw_status
from SOCIAL_MEDIA_FLOODGATES.PUBLIC.TWEET_INGEST;

select raw_status:entities
from SOCIAL_MEDIA_FLOODGATES.PUBLIC.TWEET_INGEST;

select raw_status:entities:hashtags
from tweet_ingest;

select raw_status:entities:hashtags[0]
from tweet_ingest;


select raw_status:entities:hashtags[0].text
from tweet_ingest;

select raw_status:entities:hashtags[0].text
from tweet_ingest
where raw_status:entities:hashtags[0].text is not null;

select raw_status:created_at::date
from tweet_ingest
order by raw_status:created_at::date;