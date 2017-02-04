salt-api:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - require:
      - module: generate-master-certs

pyOpenSSL:
  pkg.installed

generate-master-certs:
  module.run:
    - name: tls.create_self_signed_cert
    - require:
      - pkg: pyOpenSSL
    - unless:
      - ls /etc/pki/tls/certs/localhost.crt
