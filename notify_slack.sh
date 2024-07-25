#!/bin/bash

SLACK_WEBHOOK_URL=$1
CHANNEL=$2
STATUS=$3
TEXT=$4
THREAD_TS=$5

if [ -z "$THREAD_TS" ]; then
  curl -X POST -H 'Content-type: application/json' --data "{
    \"channel\": \"$CHANNEL\",
    \"text\": \"$TEXT\",
    \"attachments\": [{\"text\": \"Status: $STATUS\"}]
  }" $SLACK_WEBHOOK_URL
else
  curl -X POST -H 'Content-type: application/json' --data "{
    \"channel\": \"$CHANNEL\",
    \"text\": \"$TEXT\",
    \"thread_ts\": \"$THREAD_TS\",
    \"attachments\": [{\"text\": \"Status: $STATUS\"}]
  }" $SLACK_WEBHOOK_URL
fi
