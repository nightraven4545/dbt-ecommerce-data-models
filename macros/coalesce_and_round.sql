{% macro coalesce_and_round(column_name, decimal_places=2) -%}
    round(coalesce({{ column_name }}, 0), {{ decimal_places }})
{%- endmacro %}
