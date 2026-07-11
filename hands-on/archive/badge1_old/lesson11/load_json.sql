copy into LIBRARY_CARD_CATALOG.PUBLIC.AUTHOR_INGEST_JSON
from @UTIL_DB.PUBLIC.MY_INTERNAL_STAGE/author_with_header.json
file_format = (format_name = LIBRARY_CARD_CATALOG.PUBLIC.JSON_FILE_FORMAT);

select raw_author
from author_ingest_json;