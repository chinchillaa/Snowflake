create or replace dbt project dbt_learn.dbt_projects.learn_project
    from 'snow://workspace/USER$.PUBLIC."Snowflake"/versions/head/dbt/dbt_learn';