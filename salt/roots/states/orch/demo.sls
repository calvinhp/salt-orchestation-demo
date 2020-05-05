This really should have worked out better:
  test.fail_without_changes:
    - failhard: True


demo-fail:
  salt.state:
    - sls: fail
    - tgt: app1
