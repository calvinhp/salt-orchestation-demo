{% from "django/map.jinja" import django with context %}

include:
  - postgres.client
  - postgres.dev
  - python

django-deps:
    pkg.installed:
        - pkgs:
            - lynx
            - poppler-utils
            - uwsgi
            {% if grains['os_family'] == 'RedHat' %}
            - uwsgi-plugin-python
            {% endif %}
            - {{ django.deps.freetype }}
            - {{ django.deps.png }}
            - {{ django.deps.jpeg }}
            - {{ django.deps.tiff }}

/srv/django:
  file.directory:
    - user: vagrant
    - group: vagrant
    - dir_mode: 775

git-django-prod:
  git.latest:
    - name: https://github.com/sixfeetup/ElevenNote.git
    - user: vagrant
    - target: /srv/django
    - require:
      - file: /srv/django

/srv/django/venv:
  virtualenv.managed:
    - python: python3.5
    - requirements: /srv/django/elevennote/requirements/production.txt
    - require:
      - sls: python
      - pip: virtualenv
      - git: git-django-prod
      - pkg: install-postgres-dev-package

/srv/django/elevennote/config/settings/.env:
  file.managed:
    - user: vagrant
    - group: vagrant
    - mode: 664
    - source: salt://django/files/env
    - template: jinja
    - require:
      - git: git-django-prod
