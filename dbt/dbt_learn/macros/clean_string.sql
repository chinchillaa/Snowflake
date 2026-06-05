{# 
  macro: clean_string
  説明: 文字列カラムの各レコードにおいて前後の空白を除去し、大文字に変換するマクロ
  引数:
    - column_name: クリーニング対象のカラム名
  使用例: {{ clean_string('customer_name') }} → UPPER(TRIM(customer_name))
#}

{% macro clean_string(column_name) %}
    upper(trim({{ column_name }}))
{% endmacro %}