{% from "map.jinja" import global with context %}
{% from "supervisor/map.jinja" import supervisor with context %}

include:
  - python

supervisor:
  pip.installed:
    - require:
      - sls: python

superlance:
  pip.installed:
    - require:
      - sls: python

supervisord-confd:
  file.directory:
    - name: {{ supervisor.conf_dir }}
    - user: root
    - group: {{ global.group }}
    - mode: 775
    - makedirs: True
    - require_in:
      - file: supervisord-conf

supervisord-conf:
  file.managed:
    - name: {{ supervisor.conf_file }}
    - user: root
    - group: {{ global.group }}
    - mode: 664
    - source: salt://supervisor/files/supervisord.conf
    - template: jinja
    - makedirs: True
    - require:
      - pip: supervisor

supervisord-systemd:
  file.managed:
    - name: {{ supervisor.service_file }}
    - user: root
    - group: {{ global.group }}
    - mode: 644
    - source: salt://supervisor/files/supervisor.systemd

supervisord-service:
  service.running:
    - name: {{ supervisor.service }}
    - enable: True
    - require:
      - file: supervisord-systemd
