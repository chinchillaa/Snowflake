create or replace dbt project dbt_learn.dbt_projects.learn_project
    from 'snow://workspace/USER$.PUBLIC."Snowflake"/versions/head/hands-on/dbt/dbt_learn';

show dbt projects in schema dbt_learn.dbt_projects;