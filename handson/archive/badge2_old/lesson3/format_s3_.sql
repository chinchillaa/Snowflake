use role sysadmin;
use warehouse intl_wh;

show stages in account;

list @util_db.public.aws_s3_bucket;

copy into INTL_DB.PUBLIC.INT_STDS_ORG_3166
from @util_db.public.aws_s3_bucket/ISO_Countries_UTF8_pipe.csv
file_format = (format_name = UTIL_DB.PUBLIC.PIPE_DBLQUOTE_HEADER_CR);

select count(*) as found, '249' as expected
from INTL_DB.PUBLIC.INT_STDS_ORG_3166;