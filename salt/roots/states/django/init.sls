{% from "django/map.jinja" import django with context %}

include:
  - postgres.client
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
      - pip: virtualenv
      - git: git-django-prod
