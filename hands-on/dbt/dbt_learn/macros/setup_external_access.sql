{% macro setup_external_access() %}

{% set create_network_rule %}
CREATE OR REPLACE NETWORK RULE my_dbt_network_rule
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = (
    'hub.getdbt.com',
    'codeload.github.com'
  )
{% endset %}

{% set create_eai %}
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION my_dbt_ext_access
  ALLOWED_NETWORK_RULES = (my_dbt_network_rule)
  ENABLED = TRUE
{% endset %}

{% do run_query(create_network_rule) %}
{{ log("Network rule created successfully", info=True) }}

{% do run_query(create_eai) %}
{{ log("External access integration created successfully", info=True) }}

{% endmacro %}
