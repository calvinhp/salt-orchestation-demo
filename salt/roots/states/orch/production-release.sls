collectstatic:
  salt.state:
    - tgt: 'node_type:django'
    - tgt_type: grain
    - sls: django.collectstatic
