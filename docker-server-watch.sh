#!/bin/bash

HOST=https://aaaaa.com
DB_CONTAINER_NAME=xxxxxx_db_1
DEPLOY_PATH=/home/user-name/path
WEBHOOK_URL=https://hooks.slack.com/services/xxxxxx/yyyyyyy/zzzzzzzz
CHANNEL="#xxxx"
DT=`date "+%Y年%m月%d日%H時%M分%S秒"`

finally() {
  status=$?
  echo '強制終了しました'
  echo "ステータス: $status"
  echo  in trap, status captured
  DT=`date "+%Y年%m月%d日%H時%M分%S秒"`
  curl -X POST --data-urlencode 'payload={"channel": "'$CHANNEL'", "username": "PINGさん", "text": "'$DT' プロセスが終了しました。", "icon_emoji": ":desktop_computer:"}' $WEBHOOK_URL
  exit $status  
}

trap 'finally' {1,2,3,15}

curl -X POST --data-urlencode 'payload={"channel": "'$CHANNEL'", "username": "PINGさん", "text": "'$DT' これから ホスト['$HOST']を監視します", "icon_emoji": ":desktop_computer:"}' $WEBHOOK_URL

while :
do
    i=0
    STATUS=`curl -4 --head -LI ${HOST} -o /dev/null -w '%{http_code}\n' -s`
    echo $STATUS
    IS_ENTER_MYSQL=`docker exec $DB_CONTAINER_NAME bash 2>&1`
    echo $IS_ENTER_MYSQL

   if ([ "$STATUS" = "200" ] || [ "$STATUS" = '' ]) && [ "${IS_ENTER_MYSQL}" = '' ]; then
      sleep 60
    else
      i=i+1
      if [ -z "$STATUS" ]; then
        STATUS="blaaank"
      fi
      DT=`date "+%Y年%m月%d日%H時%M分%S秒"`
      echo $DT
      curl -X POST --data-urlencode 'payload={"channel": "'$CHANNEL'", "username": "CURLさん", "text": "'$DT' status code '$STATUS' ホスト['$HOST']が落ちたの", "icon_emoji": ":ghost:"}' $WEBHOOK_URL

      cd $DEPLOY_PATH
      docker-compose up -d
      sleep 60
    fi
done