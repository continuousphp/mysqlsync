#!/bin/bash

ALERT_SLACK_URL="https://hooks.slack.com/services/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" \
ALERT_SLACK_USERNAME="MysqlSync" \
ALERT_SLACK_CHANNEL="#s30" \
../bin/mysqlsync.sh \
	-c 'DST_HOST=solutions30.cwzrlsslawgf.eu-west-1.rds.amazonaws.com DST_USER=solutions30 DST_PASSWORD=Kn2#Ldn444jk[N0n?10m~sLkjdn5 SRC_HOST=testing-diff-structure.cwzrlsslawgf.eu-west-1.rds.amazonaws.com SRC_USER=root SRC_PASSWORD=Nhfl#454!h-KhfIw' \
	schema
