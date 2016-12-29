#!/bin/bash

notification()
{
	sns "$@"
	slack "$@"
}

sns()
{
	if [ -n ${ALERT_SNS_ARN} ]
	then
		aws --region ${ALERT_SNS_REGION} sns publish \
		--topic-arn "${ALERT_SNS_ARN}" \
		--subject "WARNING: MysqlSync Schema Service" \
		--message "$1"
	fi
}

slack()
{
	if [ -z ${ALERT_SLACK_URL+x} ]
	  then
		echo "missing variable ALERT_SLACK_URL"
		return
	fi

	if [ -z ${ALERT_SLACK_USERNAME+x} ]
	  then
		echo "missing variable ALERT_SLACK_USERNAME"
		return
	fi

	if [ -z ${ALERT_SLACK_CHANNEL+x} ]
	  then
		echo "missing variable ALERT_SLACK_CAHNNEL"
		return
	fi

	text=$1
	icon=$2

	if [ "$text" == "" ]
	  then
		echo "First argument must be text of the notification"
		exit 1
	fi

	if [ "$icon" == "" ]
	  then
		icon=":information_source:"
	fi

	payload='payload={"channel": "'${ALERT_SLACK_CHANNEL}'", "username": "'${ALERT_SLACK_USERNAME}'", "text": "'$text'", "icon_emoji": "'$icon'"}'
	
	curl -X POST --data-urlencode "$payload" $ALERT_SLACK_URL &>/dev/null &
}

