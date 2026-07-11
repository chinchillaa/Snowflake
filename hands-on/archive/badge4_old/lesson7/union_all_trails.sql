select feature_name, geometry, trail_length
from denver_area_trails
union all
select feature_name, geometry, trail_length
from denver_area_trails_2;

create or replace view MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.trails_and_boundaries as
select feature_name,
to_geography(geometry) as my_linestring,
st_xmin(my_linestring) as min_eastwest,
st_xmax(my_linestring) as max_eastwest,
st_ymin(my_linestring) as min_northsouth,
st_ymax(my_linestring) as max_northsouth,
trail_length
from MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.DENVER_AREA_TRAILS
union all
select feature_name,
to_geography(geometry) as my_linestring,
st_xmin(my_linestring) as min_eastwest,
st_xmax(my_linestring) as max_eastwest,
st_ymin(my_linestring) as min_northsouth,
st_ymax(my_linestring) as max_northsouth,
trail_length
from MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.DENVER_AREA_TRAILS_2;

select *
from trails_and_boundaries;