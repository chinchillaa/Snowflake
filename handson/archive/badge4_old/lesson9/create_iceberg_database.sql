create database my_iceberg_db
  catalog = 'SNOWFLAKE'
  external_volume = 'iceberg_external_volume';

set table_name = 'CCT_'||current_account();
select $table_name;

create iceberg table identifier($table_name) (
    point_id number(10,0),
    trail_name string,
    coord_pair string,
    distance_to_melanies decimal(20,10),
    user_name string
)
  base_location = $table_name
  as
  select top 100
      point_id,
      trail_name,
      coord_pair,
      distance_to_melanies,
      current_user()
  from MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.SMV_CHERRY_CREEK_TRAIL;

select * from identifier($table_name);

update identifier($table_name)
set user_name = 'I am amazing!!'
where point_id = 1;