create or replace view MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.denver_area_trails_2 as (
select trail_name as feature_name,
'{"coordinates":[' || listagg('[' || lng || ',' || lat || ']',',') within group (order by point_id) ||'],"type":"LineString"}' as geometry,
st_length(to_geography(geometry)) as trail_length
from MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.CHERRY_CREEK_TRAIL
group by trail_name
);