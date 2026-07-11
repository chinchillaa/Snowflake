select raw_author:AUTHOR_UID
from author_ingest_json;

select 
raw_author:AUTHOR_UID
,raw_author:FIRST_NAME::string as first_name
,raw_author:MIDDLE_NAME::string as middle_name
,raw_author:LAST_NAME::string as last_name
from author_ingest_json;
