{% macro limit_in_dev(row_count=1000) %}
    {% if target.name == 'dev' %}
    LIMIT {{ row_count }}
    {% endif %}
{% endmacro %}
