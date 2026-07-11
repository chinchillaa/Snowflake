select *
from table(dbt_learn.information_schema.task_history(
    task_name => 'daily_dbt_build',
    scheduled_time_range_start => dateadd(hour, -24, current_timestamp())
))
order by scheduled_time desc;