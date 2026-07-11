execute dbt project dbt_learn.dbt_projects.learn_project
    args = 'run';

execute dbt project dbt_learn.dbt_projects.learn_project
    args = 'test';

execute dbt project dbt_learn.dbt_projects.learn_project
    args = 'run --select fct_orders';

execute dbt project dbt_learn.dbt_projects.learn_project
    args = 'build';

execute dbt project dbt_learn.dbt_projects.learn_project
    args = 'show --select stg_orders --limit 5';