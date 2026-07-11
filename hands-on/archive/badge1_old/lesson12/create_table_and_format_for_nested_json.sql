create or replace table library_card_catalog.public.nested_ingest_json
(
    raw_nested_book VARIANT
);

copy into LIBRARY_CARD_CATALOG.PUBLIC.NESTED_INGEST_JSON
from @UTIL_DB.PUBLIC.MY_INTERNAL_STAGE/json_book_author_nested.txt
file_format = (format_name = LIBRARY_CARD_CATALOG.PUBLIC.JSON_FILE_FORMAT);