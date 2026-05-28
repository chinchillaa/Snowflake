{% macro clean_string(column_name) %}
    UPPER(TRIM({{ column_name }}))
{% endmacro %}
