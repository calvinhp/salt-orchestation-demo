{% from "map.jinja" import global with context %}

include:
  - selinux

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

nginx-selinx:
  file.managed:
    - name: /root/nginx.pp
    - user: root
    - group: root
    - mode: 644
    - source: salt://nginx/files/nginx.pp
    - require_in:
      - cmd: /usr/sbin/semodule -i /root/nginx.pp

  cmd.run:
    - name: /usr/sbin/semodule -i /root/nginx.pp
    - onchanges:
      - file: /root/nginx.pp

  selinux.module:
    - name: nginx
    - module_state: enabled
    - require:
      - pkg: policycoreutils
      - pkg: policycoreutils-python
