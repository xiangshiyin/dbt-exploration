
{% macro get_model_path(model_name) %}
    {% set model = ref(model_name) %}
    {% set file_path = model.source_file_path %}
    {{ log(model, info=True) }}
    {{ log(file_path, info=True) }}
{% endmacro %}