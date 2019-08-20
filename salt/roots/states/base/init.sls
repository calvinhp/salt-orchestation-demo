{% from "base/map.jinja" import base with context %}

base-packages:
  pkg.installed:
    - pkgs:
      - unzip
      - dmidecode
      - git
      - {{ base.bzip2 }}
      - {{ base.libxml2 }}
      - {{ base.libxslt }}
      - {{ base.sqlite }}
{% if grains['os_family'] == 'Debian' %}
      - libssl-dev
      - tmpreaper
      - mailutils
{% endif %}
