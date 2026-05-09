select count(*) as objects_found
from INTL_DB.INFORMATION_SCHEMA.TABLES
where table_schema = 'PUBLIC'
and table_name = 'INT_STDS_ORG_3166';

select row_count
from INTL_DB.INFORMATION_SCHEMA.TABLES
where table_schema = 'PUBLIC'
and table_name = 'INT_STDS_ORG_3166';