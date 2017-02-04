disable-app1:
  salt.function:
    - name: haproxy.disable_server
    - tgt: proxy
    - arg:
      - app1
      - django

restart-app1:
  salt.function:
    - name: supervisord.restart
    - tgt: app1

sleep-app1:
  salt.function:
    - name: cmd.run
    - tgt: app1
    - arg:
      - sleep 10

enable-app1:
  salt.function:
    - name: haproxy.enable_server
    - tgt: proxy
    - arg:
      - app1
      - django
