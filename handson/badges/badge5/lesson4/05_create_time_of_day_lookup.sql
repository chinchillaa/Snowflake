create or replace table ags_game_audience.raw.time_of_day_lu(
hour number,
tod_name varchar(25)
)
;

insert into ags_game_audience.raw.time_of_day_lu
values
(6,'Early morning'),
(7,'Early morning'),
(8,'Early morning'),
(9,'Mid-morning'),
(10,'Mid-morning'),
(11,'Late morning'),
(12,'Late morning'),
(13,'Early afternoon'),
(14,'Early afternoon'),
(15,'Mid-afternoon'),
(16,'Mid-afternoon'),
(17,'Late afternoon'),
(18,'Late afternoon'),
(19,'Early evening'),
(20,'Early evening'),
(21,'Late evening'),
(22,'Late evening'),
(23,'Late evening'),
(0,'Late at night'),
(1,'Late at night'),
(2,'Late at night'),
(3,'Toward morning'),
(4,'Toward morning'),
(5,'Toward morning');

select tod_name, listagg(hour, ',') as hour_list
from AGS_GAME_AUDIENCE.RAW.TIME_OF_DAY_LU
group by tod_name
;
