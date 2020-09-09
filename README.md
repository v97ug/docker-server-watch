# docker-server-watch

Shell script in order to watch Docker container. The script and Docker contaier is needed to be in the same server.

# How it works?

```bash
$ ./docker-server-watch.sh
```

# Option

| option | description | example |
| ---- | ---- | ---- |
| HOST | server url you want to watch | https://aaaaa.com | 
| DB_CONTAINER_NAME | Docker container name of when you build DB container | xxxxxx_db_1 |
| DEPLOY_PATH | server file path | /home/user-name/path |
| WEBHOOK_URL | Slack webhook url | https://hooks.slack.com/services/xxxxxx/yyyyyyy/zzzzzzzz |
| CHANNEL | Slack channel name | "#xxxx" |