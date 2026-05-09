select 'LINESTRING(' || listagg(coord_pair, ',') within group (order by point_id) || ')' as my_linestring,
st_length(TO_GEOGRAPHY(my_linestring)) as length_of_trail
from MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.CHERRY_CREEK_TRAIL
group by trail_name;