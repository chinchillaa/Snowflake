create or replace file format util_db.public.PIPE_DBLQUOTE_HEADER_CR
    type = 'CSV'
    compression = 'AUTO'
    field_delimiter = '|'
    record_delimiter = '\r'
    skip_header = 1
    field_optionally_enclosed_by = '\042'
    trim_space = FALSE
    ;