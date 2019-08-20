{% from "map.jinja" import global with context %}

nginx:
  pkg.installed

nginx-config:
  file.managed:
    - name: {{ global.config_prefix }}/nginx/nginx.conf
    - user: root
    - group: {{ global.group }}
    - mode: 664
    - source: salt://nginx/files/nginx.conf
    - require:
      - pkg: nginx

nginx-service:
  service.running:
    - name: nginx
    - enable: True
    - require:
      - file: nginx-config
    - watch:
      - file: nginx-config
