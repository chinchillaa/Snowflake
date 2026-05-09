create table INTL_DB.PUBLIC.currencies(
    currency_ID integer,
    currency_char_code varchar(3),
    currency_symbol varchar(4),
    currency_digital_code varchar(3),
    currency_digital_name varchar(30)
)
comment = '通貨に関する情報（文字コード、記号、デジタルコードなど）';

create table INTL_DB.PUBLIC.country_code_to_currency_code(
    country_char_code varchar(3),
    country_numeric_code integer,
    country_name varchar(100),
    currency_name varchar(100),
    currency_char_code varchar(3),
    currency_numeric_code integer
)
comment = '通貨と国のマッピングテーブル';

create or replace file format INTL_DB.PUBLIC.csv_comma_lf_header
    type = 'csv'
    field_delimiter = ','
    record_delimiter = '\n'
    skip_header = 1
    ;

copy into INTL_DB.PUBLIC.CURRENCIES
from @UTIL_DB.PUBLIC.MY_INTERNAL_STAGE/currencies.xls
file_format = (format_name = INTL_DB.PUBLIC.CSV_COMMA_LF_HEADER);

copy into INTL_DB.PUBLIC.COUNTRY_CODE_TO_CURRENCY_CODE
from @UTIL_DB.PUBLIC.MY_INTERNAL_STAGE/country_code_to_currency_code.xls
file_format = (format_name = INTL_DB.PUBLIC.CSV_COMMA_LF_HEADER);




