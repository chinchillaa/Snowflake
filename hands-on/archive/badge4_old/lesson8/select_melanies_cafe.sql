set mc_lng = '-104.97300245114094';
set mc_lat='39.76471253574085';

set loc_lng='-105.00840763333615'; 
set loc_lat='39.754141917497826';

select st_makepoint($mc_lng, $mc_lat) as melanies_cafe_point;
select st_makepoint($loc_lng,$loc_lat) as confluent_park_point;

select st_distance(
    st_makepoint($mc_lng, $mc_lat),
    st_makepoint($loc_lng,$loc_lat)
) as mc_to_cp;