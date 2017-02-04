base:
  'app*':
    - developers
    - postgresql
    - django
    - loadbalancer
  'db':
    - dbas
    - postgresql
  'proxy':
    - sysadmins
  'salt':
    - sysadmins
    - developers
    - dbas
