create view INTL_DB.PUBLIC.simple_currency(cty_code, cur_code) as
select
    country_char_code,
    currency_char_code
from
    INTL_DB.PUBLIC.COUNTRY_CODE_TO_CURRENCY_CODE;