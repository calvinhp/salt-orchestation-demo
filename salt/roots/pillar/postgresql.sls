postgres:
  # Set True to configure upstream postgresql.org repository for YUM or APT
  use_upstream_repo: True
  # Version to install from upstream repository
  version: '9.6'

  # These are Debian/Ubuntu specific package names
  pkg: 'postgresql96-server'
  pkg_client: 'postgresql96'

  # Additional packages to install with PostgreSQL server,
  # this should be in a list format
  pkgs_extra:
    - postgresql96-contrib

  # Append the lines under this item to your postgresql.conf file.
  # Pay attention to indent exactly with 4 spaces for all lines.
  postgresconf: |
    listen_addresses = '*'  # listen on all interfaces

  # Path to the `pg_hba.conf` file Jinja template on Salt Fileserver
  pg_hba.conf: salt://postgres/templates/pg_hba.conf.j2

  acls:
    - ['host', 'elevennote_dev', 'elevennote_dev', '10.10.10.0/24']
    - ['host', 'elevennote_prod', 'elevenote_prod', '10.10.10.0/24']

  # PostgreSQL service name
  service: postgresql-9.6

  users:
    elevennote_dev:
      ensure: present
      password: '98ruj923h4rf'
      createdb: False
      createroles: False
      createuser: False
      inherit: True
      replication: False

    elevennote_prod:
      ensure: present
      password: '98ruj923h4rf'
      createdb: False
      createroles: False
      createuser: False
      inherit: True
      replication: False

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
