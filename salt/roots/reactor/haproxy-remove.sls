{% if data['id'].startswith('app') and data['act'] == 'delete' %}
highstate_run:
  local.state.apply:
    - tgt: proxy
{% endif %}
