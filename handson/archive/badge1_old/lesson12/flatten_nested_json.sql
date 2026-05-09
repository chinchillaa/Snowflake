select value:first_name
from LIBRARY_CARD_CATALOG.PUBLIC.NESTED_INGEST_JSON
, lateral flatten(input => raw_nested_book:authors);

select value:first_name
from LIBRARY_CARD_CATALOG.PUBLIC.NESTED_INGEST_JSON
,table(flatten(raw_nested_book:authors));

select value:first_name::varchar, value:last_name::varchar
from LIBRARY_CARD_CATALOG.PUBLIC.NESTED_INGEST_JSON
, lateral flatten(input => raw_nested_book:authors);

select value:first_name::varchar as first_nm
from LIBRARY_CARD_CATALOG.PUBLIC.NESTED_INGEST_JSON
,table(flatten(raw_nested_book:authors));