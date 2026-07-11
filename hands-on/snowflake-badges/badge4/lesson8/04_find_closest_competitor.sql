select name,
cuisine,
st_distance(st_makepoint('-104.97300245114094','39.76471253574085'), coordinates) as distance_to_melanies,
*
from MELS_SMOOTHIE_CHALLENGE_DB.LOCATIONS.COMPETITION
order by distance_to_melanies;