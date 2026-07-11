create or replace file format ZENAS_ATHLEISURE_DB.PRODUCTS.zmd_file_format_1
    record_delimiter = ';'
    trim_space = TRUE
    ;

list @ZENAS_ATHLEISURE_DB.PRODUCTS.PRODUCT_METADATA;

create or replace view ZENAS_ATHLEISURE_DB.PRODUCTS.sweatsuit_sizes as
select replace($1, chr(13)||chr(10)) as sizes_available
from @ZENAS_ATHLEISURE_DB.PRODUCTS.PRODUCT_METADATA/sweatsuit_sizes.txt
(file_format => ZENAS_ATHLEISURE_DB.PRODUCTS.ZMD_FILE_FORMAT_1)
where sizes_available <> '';