create or replace view MELS_SMOOTHIE_CHALLENGE_DB.locations.competition as
select *
from OPENSTREETMAP_DENVER.DENVER.V_OSM_DEN_AMENITY_SUSTENANCE
where (amenity in ('fast_food','cafe','restaurant','juice_bar')) and
(name like '%jamba%' or name like '%juice%' or name like '%superfruit%')
or
(cuisine like '%smoothie%' or cuisine like '%juice%');