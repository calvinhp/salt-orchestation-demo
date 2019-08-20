{% from "map.jinja" import global with context %}
{% from "django/map.jinja" import django with context %}
{% from "supervisor/map.jinja" import supervisor with context %}

include:
  - postgres.client
  - postgres.dev
  - python
  - nginx
  - supervisor
  - uwsgi
  - django.code
  - django.collectstatic

django-deps:
    pkg.installed:
        - pkgs:
            - lynx
            - poppler-utils
            - {{ django.deps.freetype }}
            - {{ django.deps.png }}
            - {{ django.deps.jpeg }}
            - {{ django.deps.tiff }}

/srv/django:
  file.directory:
    - user: vagrant
    - group: vagrant
    - dir_mode: 775
    - require_in:
      - git: git-django-prod

/srv/django/venv:
  virtualenv.managed:
    - python: python3.6
    - requirements: /srv/django/elevennote/requirements/production.txt
    - require:
      - sls: python
      - pip: virtualenv
      - git: git-django-prod
      - pkg: install-postgres-dev-packages
    - require_in:
      - module: django_collectstatic

/srv/django/elevennote/config/settings/.env:
  file.managed:
    - user: vagrant
    - group: vagrant
    - mode: 664
    - source: salt://django/files/env
    - template: jinja
    - require:
      - git: git-django-prod
    - require_in:
      - file: uwsgi-django-config

nginx-django-config:
  file.managed:
    - name: {{ global.config_prefix }}/nginx/conf.d/django.conf
    - user: root
    - group: {{ global.group }}
    - mode: 664
    - makedirs: True
    - source: salt://django/files/nginx-django.conf
    - template: jinja
    - require:
      - file: nginx-config
    - listen_in:
      - service: nginx-service

uwsgi-django-config:
  file.managed:
    - name: {{ global.config_prefix }}/uwsgi.d/django.ini
    - user: root
    - group: {{ global.group }}
    - mode: 664
    - makedirs: True
    - source: salt://django/files/uwsgi-django.ini
    - template: jinja
    - require:
       - pkg: uwsgi-plugin-python3
       - file: uwsgi-config-dir
       - virtualenv: /srv/django/venv

supervisor-django-config:
  file.managed:
    - name: {{ supervisor.conf_dir }}/django.conf
    - user: root
    - group: {{ global.group }}
    - mode: 664
    - makedirs: True
    - source: salt://django/files/supervisor-django.conf
    - template: jinja
    - require:
      - file: supervisord-confd
      - file: uwsgi-django-config
    - require_in:
      - service: supervisord-service

django_migrate:
  module.run:
    - name: django.command
    - settings_module: config.settings.production
    - bin_env: /srv/django/venv
    - pythonpath: /srv/django/{{ salt['pillar.get']('django:projectname') }}
    - command: migrate
    - require:
      - git: git-django-prod
      - virtualenv: /srv/django/venv
