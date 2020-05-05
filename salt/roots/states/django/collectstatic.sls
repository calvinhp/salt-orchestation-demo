django_collectstatic:
  module.run:
    - name: django.collectstatic
    - settings_module: config.settings.production
    - bin_env: /srv/django/venv
    - pythonpath: /srv/django
