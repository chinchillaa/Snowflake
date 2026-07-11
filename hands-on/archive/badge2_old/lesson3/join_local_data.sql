select iso_country_name, country_name_official, alpha_code_2digit, r_name as region
from INTL_DB.PUBLIC.INT_STDS_ORG_3166 int3166
left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION nat
on upper(int3166.iso_country_name) = nat.n_name
left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.REGION reg
on n_regionkey = r_regionkey;