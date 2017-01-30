{% from "users/map.jinja" import users with context -%}

include:
  - users

{% set userfile_dirs = salt['cp.list_master_dirs'](prefix='users/files/user/') -%}
{%- for username, user in salt['pillar.get']('users', {}).items() if (user.absent is not defined or not user.absent) -%}
{%- set current = salt.user.info(username) -%}
{%- set user_files = salt['pillar.get'](('users:' ~ username ~ ':user_files'), {'enabled': False}) -%}
{%- set user_group = salt['pillar.get'](('users:' ~ username ~ ':prime_group:name'), username) -%}
{%- set user_home = salt['pillar.get'](('users:' ~ username ~ ':home'), current.get('home', '/home/' ~ username )) -%}
{%- if user_files.enabled -%}

{%- if user_files.source is defined -%}
    {%- if user_files.source.startswith('salt://') -%}
        {%- set file_source = user_files.source -%}
    {%- else -%}
        {%- set file_source = ('salt://' ~ user.user_files.source) -%}
    {%- endif -%}
    {%- set skip_user = False -%}
{%- else -%}
    {%- if ('users/files/user/' ~ username) in userfile_dirs -%}
        {%- set file_source = ('salt://users/files/user/' ~ username) -%}
        {%- set skip_user = False -%}
    {%- else -%}
        {%- set skip_user = True -%}
    {%- endif -%}
{%- endif -%}

{%- if not skip_user %}
users_userfiles_{{ username }}_recursive:
  file.recurse:
    - name: {{ user_home }}
    - source: {{ file_source }}
    - user: {{ username }}
    - group: {{ user_group }}
    - clean: False
    - include_empty: True
    - keep_symlinks: True
    - require:
      - user: users_{{ username }}_user
      - file: users_{{ username }}_user
{% endif -%}

{%- endif -%}
{%- endfor -%}
