select feature_name,
st_length(to_geography(whole_object)) as wo_length,
st_length(to_geography(geometry)) as geom_length,
from MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.DENVER_AREA_TRAILS;

select get_ddl('view', 'DENVER_AREA_TRAILS');

create or replace view MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.DENVER_AREA_TRAILS as (
select 
$1:features[0]:properties:Name::string as feature_name,
$1:features[0]:geometry:coordinates::string as feature_coordinates,
$1:features[0]:geometry::string as geometry,
$1:features[0]:properties::string as feature_properties,
$1:crs:properties:name::string as specs,
$1 as whole_object,
st_length(to_geography(whole_object)) as trail_length
from @MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.TRAILS_GEOJSON(
file_format => MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.FF_JSON)
);
