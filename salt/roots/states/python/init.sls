{% from "python/map.jinja" import python with context %}

pip:
  pkg.installed:
    - name: {{ python.pip_pkg }}

python-dev-packages:
  pkg.installed:
    - pkgs: {{ python.dev_pkgs }}
    - require:
      - pkg: pip

virtualenv:
  pip.installed:
    - require:
      - pkg: pip

install-python35:
  cmd.run:
    - env:
      - PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    - name: |
        curl -sO https://www.python.org/ftp/python/3.5.3/Python-3.5.3.tar.xz
        tar -xJf Python-3.5.3.tar.xz
        cd Python-3.5.3
        ./configure --prefix=/usr/local --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
        make
        make altinstall
    - cwd: /tmp
    - unless: which python3.5
    - require:
      - pkg: python-dev-packages

