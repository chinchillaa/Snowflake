use role sysadmin;
use database LIBRARY_CARD_CATALOG;

create or replace sequence LIBRARY_CARD_CATALOG.PUBLIC.SEQ_AUTHOR_UID start with 1 increment by 1 order;

select seq_author_uid.nextval;

show sequences;