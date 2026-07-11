select gamer_name, count(gamer_name)
from AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED
group by gamer_name;
