create or replace task dbt_learn.dbt_projects.daily_dbt_build
    warehouse = compute_wh
    schedule = 'USING CRON 0 6 * * * UTC'
as
    execute dbt project dbt_learn.dbt_projects.learn_project
        args = 'build';

ALTER TASK DBT_LEARN.DBT_PROJECTS.DAILY_DBT_BUILD RESUME;

SHOW TASKS IN SCHEMA DBT_LEARN.DBT_PROJECTS;