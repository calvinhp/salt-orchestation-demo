{% for app_server in ['app1','app2'] %}
release-latest-{{app_server}}:
  salt.state:
    - tgt: {{ app_server }}
    - sls: django.code

collectstatic-{{app_server}}:
  salt.state:
    - tgt: {{ app_server }}
    - sls: django.collectstatic

disable-{{ app_server }}:
  salt.function:
    - name: haproxy.disable_server
    - tgt: proxy
    - arg:
      - {{ app_server }}
      - django

restart-instances-{{app_server}}:
  salt.function:
    - tgt: {{ app_server }}
    - name: supervisord.restart

sleep-{{ app_server }}:
  salt.function:
    - name: cmd.run
    - tgt: {{ app_server }}
    - arg:
      - sleep 6

enable-{{ app_server }}:
  salt.function:
    - name: haproxy.enable_server
    - tgt: proxy
    - arg:
      - {{ app_server }}
      - django
{% endfor %}
