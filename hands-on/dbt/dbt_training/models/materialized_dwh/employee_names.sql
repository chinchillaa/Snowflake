SELECT
    "employee_id",
    concat("first_name", ' ', "last_name") AS "full_name"

from
    "dbt_training"."raw"."employees"