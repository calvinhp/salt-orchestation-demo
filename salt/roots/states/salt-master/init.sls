{% from "map.jinja" import global with context %}

jq:
  pkg.installed

salt-master:
  service.running:
    - enable: true

salt-api:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - require:
      - module: generate-master-certs

python-openssl:
  pkg.installed

generate-master-certs:
  module.run:
    - name: tls.create_self_signed_cert
    - require:
      - pkg: python-openssl
    - unless:
      - ls /etc/pki/tls/certs/localhost.crt

/etc/salt/master.d/api.conf:
  file.managed:
    - user: root
    - group: {{ global.group }}
    - mode: 664
    - source: salt://salt-master/files/api.conf
    - listen_in:
      - service: salt-master

/etc/salt/master.d/reactor.conf:
  file.managed:
    - user: root
    - group: {{ global.group }}
    - mode: 664
    - source: salt://salt-master/files/reactor.conf
    - listen_in:
      - service: salt-master
