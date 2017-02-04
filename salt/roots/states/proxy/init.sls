{% from "map.jinja" import global with context %}

include:
  - python

haproxyctl:
  pip.installed

haproxy:
  pkg:
    - installed
  service:
    - running
    - enable: true
    - watch:
      - file: /etc/haproxy/haproxy.cfg

/etc/haproxy/haproxy.cfg:
  file.managed:
    - user: root
    - group: {{ global.group }}
    - mode: 664
    - source: salt://proxy/files/haproxy.cfg
    - template: jinja
    - require:
      - pkg: haproxy
