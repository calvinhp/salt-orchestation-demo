{% from "map.jinja" import global with context %}

include:
  - supervisor

uwsgi:
  pkg.installed

uwsgi-plugin-python3:
  pkg.installed

uwsgi-log-dir:
  file.directory:
    - name: /var/log/uwsgi
    - user: root
    - group: {{ global.group }}
    - makedirs: True
    - dir_mode: 775
    - require_in:
      - service: supervisord-service

uwsgi-log-file:
  file.touch:
    - name: /var/log/uwsgi/out.log
    - require:
      - file: uwsgi-log-dir
    - require_in:
      - service: supervisord-service

uwsgi-err-log-file:
  file.touch:
    - name: /var/log/uwsgi/err.log
    - require:
      - file: uwsgi-log-dir
    - require_in:
      - service: supervisord-service

uwsgi-config-dir:
  file.directory:
    - name: {{ global.config_prefix }}/uwsgi.d
    - user: root
    - group: {{ global.group }}
    - makedirs: True
    - dir_mode: 775
