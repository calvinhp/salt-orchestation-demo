# -*- coding: utf-8 -*-
# vim: ft=yaml
---
# Port to use for the cluster -- can be used to provide a non-standard port
# NOTE: If already set in the minion config, that value takes priority
postgres.port: '5432'

postgres:
  # UPSTREAM REPO
  # Set true to configure upstream postgresql.org repository for YUM/APT/ZYPP
  use_upstream_repo: false
  # Version to install from upstream repository (if upstream_repo: true)
  version: '10'
  # Set true to add a file in /etc/profile.d adding the bin dir in $PATH
  # as packages from upstream put them somewhere like /usr/pgsql-10/bin
  add_profile: false
  # If automatic package installation fails, use `fromrepo` to specify the
  # upstream repo to install packages from [#133, #185] (if upstream_repo: true)
  # fromrepo: 'jessie-pgdg'

  ### MACOS
  # Set to 'postgresapp' OR 'homebrew' for MacOS
  # use_upstream_repo: 'postgresapp'
  # use_upstream_repo: 'homebrew'

  # PACKAGE
  # These pillars are typically never required.
  # pkg: 'postgresql'
  # pkg_client: 'postgresql-client'
  # service:
  #   name: 'postgresql'
  #   flags: -w -s -m fast
  #   sysrc: true
  pkgs_extra:
    - postgresql-contrib
    - postgresql-plpython-10

  # CLUSTER
  # The default `encoding` is derived from the `locale` so not recommended
  # to provide a value for it unless necessary
  cluster:
    locale: en_US.UTF-8
    # encoding: UTF8

  # 'Alternatives system' priority incremental. 0 disables feature.
  linux:
    altpriority: 30

  # macos limits
  limits:
    soft: 64000
    hard: 128000

  # POSTGRES
  # Append the lines under this item to your postgresql.conf file.
  # Pay attention to indent exactly with 4 spaces for all lines.
  postgresconf: |-
    listen_addresses = '*'  # listen on all interfaces

  # Path to the `pg_hba.conf` file Jinja template on Salt Fileserver
  pg_hba.conf: salt://postgres/templates/pg_hba.conf.j2

  # This section covers ACL management in the ``pg_hba.conf`` file.
  # acls list controls: which hosts are allowed to connect, how clients
  # are authenticated, which PostgreSQL user names they can use, which
  # databases they can access. Records take one of these forms:
  #
  # acls:
  #  - ['local', 'DATABASE',  'USER',  'METHOD']
  #  - ['host', 'DATABASE',  'USER',  'ADDRESS', 'METHOD']
  #  - ['hostssl', 'DATABASE', 'USER', 'ADDRESS', 'METHOD']
  #  - ['hostnossl', 'DATABASE', 'USER', 'ADDRESS', 'METHOD']
  #
  # The uppercase items must be replaced by actual values.
  # METHOD could be omitted, 'md5' will be appended by default.
  #
  # If ``acls`` item value is empty ('', [], null), then the contents of
  # ``pg_hba.conf`` file will not be touched at all.
  acls:
    - ['host', 'elevennote_dev', 'elevennote_dev', '10.10.10.0/24']
    - ['host', 'elevennote_prod', 'elevennote_prod', '10.10.10.0/24']

  # Backup extension for configuration files, defaults to ``.bak``.
  # Set ``false`` to stop creation of backups when config files change.
  {%- if salt['status.time']|default(none) is callable %}
  config_backup: ".backup@{{ salt['status.time']('%y-%m-%d_%H:%M:%S') }}"
  {%- endif %}

  {%- if grains['init'] == 'unknown' %}

  # If Salt is unable to detect init system running in the scope of state run,
  # probably we are trying to bake a container/VM image with PostgreSQL.
  # Use ``bake_image`` setting to control how PostgreSQL will be started: if set
  # to ``true`` the raw ``pg_ctl`` will be utilized instead of packaged init
  # script, job or unit run with Salt ``service`` state.
  bake_image: true

  {%- endif %}

  # Create/remove users, tablespaces, databases, schema and extensions.
  # Each of these dictionaries contains PostgreSQL entities which
  # mapped to the ``postgres_*`` Salt states with arguments. See the Salt
  # documentation to get all supported argument for a particular state.
  #
  # Format is the following:
  #
  # <users|tablespaces|databases|schemas|extensions>:
  #  NAME:
  #    ensure: <present|absent>  # 'present' is the default
  #    ARGUMENT: VALUE
  #    ...
  #
  # where 'NAME' is the state name, 'ARGUMENT' is the kwarg name, and
  # 'VALUE' is kwarg value.
  #
  # For example, the Pillar:
  #
  # users:
  #  testUser:
  #    password: test
  #
  # will render such state:
  #
  # postgres_user-testUser:
  #  postgres_user.present:
  #    - name: testUser
  #    - password: test
  users:
    elevennote_dev:
      ensure: present
      password: '98ruj923h4rf'
      createdb: false
      createroles: false
      inherit: true
      replication: false

    elevennote_prod:
      ensure: present
      password: '98ruj923h4rf'
      createdb: false
      createroles: false
      inherit: true
      replication: false


  # databases to be created
  databases:
    elevennote_dev:
      owner: 'elevennote_dev'
      template: 'template0'
      lc_ctype: 'en_US.UTF-8'
      lc_collate: 'en_US.UTF-8'
    elevennote_prod:
      owner: 'elevennote_prod'
      template: 'template0'
      lc_ctype: 'en_US.UTF-8'
      lc_collate: 'en_US.UTF-8'

# vim: ft=yaml ts=2 sts=2 sw=2 et
