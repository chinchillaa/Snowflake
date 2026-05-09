use role sysadmin;

create or replace warehouse INTL_WH
with
    warehouse_size = 'XSMALL'
    warehouse_type = 'STANDARD'
    auto_suspend = 600
    auto_resume = TRUE;

use warehouse INTL_WH;