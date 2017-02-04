{% if data['id'].startswith('app') and data['fun'] == 'state.apply' %}
highstate_run:
  local.state.apply:
    - tgt: proxy
{% endif %}
