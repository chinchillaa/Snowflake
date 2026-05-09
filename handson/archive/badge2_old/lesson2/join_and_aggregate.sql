select n_nationkey, n_name, n_regionkey
from snowflake_sample_data.tpch_sf1.nation;

select r_regionkey, r_name
from snowflake_sample_data.tpch_sf1.region;

-- join nation and region table on regionkey
select r_name as region, n_name as nation
from snowflake_sample_data.tpch_sf1.nation
join snowflake_sample_data.tpch_sf1.region
on n_regionkey = r_regionkey
order by r_name, n_name asc;

select r_name as region, count(n_name) as num_countries
from snowflake_sample_data.tpch_sf1.nation
join snowflake_sample_data.tpch_sf1.region
on n_regionkey = r_regionkey
group by r_name;

