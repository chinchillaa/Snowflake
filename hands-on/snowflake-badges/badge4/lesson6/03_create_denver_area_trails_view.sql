select *
from @MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.TRAILS_GEOJSON(
file_format => MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.FF_JSON);


create or replace view denver_area_trails as (
select 
$1:features[0]:properties:Name::string as feature_name,
$1:features[0]:geometry:coordinates::string as feature_coordinates,
$1:features[0]:geometry::string as geometry,
$1:features[0]:properties::string as feature_properties,
$1:crs:properties:name::string as specs,
$1 as whole_object
from @MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.TRAILS_GEOJSON(
file_format => MELS_SMOOTHIE_CHALLENGE_DB.TRAILS.FF_JSON)
);