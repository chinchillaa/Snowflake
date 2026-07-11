{% macro log_model_run(model_name) %}
INSERT INTO DBT_LEARN.ANALYTICS.DBT_RUN_LOG (model_name) VALUES ('{{ model_name }}')
{% endmacro %}
