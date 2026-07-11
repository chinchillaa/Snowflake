alter database SNOWFLAKESNOWFLAKE_SAMPLE_DATA
rename to snowflake_sample;

-- 
select distinct c_mktsegment
from snowflake_sample_data.tpch_sf1.customer;

select c_mktsegment, count(*)
from snowflake_sample_data.tpch_sf1.customer
group by c_mktsegment
order by count(*);

--