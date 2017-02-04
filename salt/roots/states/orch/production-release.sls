release-latest:
  salt.state:
    - tgt: 'node_type:django'
    - tgt_type: grain
    - sls: django.code

collectstatic:
  salt.state:
    - tgt: 'node_type:django'
    - tgt_type: grain
    - sls: django.collectstatic

restart-instances:
  salt.function:
    - name: supervisord.restart
    - tgt: 'app*'
