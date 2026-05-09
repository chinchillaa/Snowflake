select parse_ip('100.41.16.160', 'inet'):ipv4;

select start_ip, end_ip, start_ip_int, end_ip_int, city, region, country, timezone
from IPINFO_GEOLOC.DEMO.LOCATION
where parse_ip('100.41.16.160', 'inet'):ipv4 between start_ip_int and end_ip_int;

select logs.*,
loc.city,
loc.region,
loc.country,
loc.timezone
from AGS_GAME_AUDIENCE.RAW.LOGS logs
join IPINFO_GEOLOC.DEMO.LOCATION loc
where parse_ip(logs.ip_address, 'inet'):ipv4
between start_ip_int and start_ip_int;
