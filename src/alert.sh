#!/bin/bash

sns()
{
	echo "NOT YET IMPLEMENTED"
	exit 2
}

slack()
{
	if [ -z ${ALERT_SLACK_URL+x} ]
	  then
		echo "missing variable ALERT_SLACK_URL"
		exit 1
	fi

	if [ -z ${ALERT_SLACK_USERNAME+x} ]
	  then
		echo "missing variable ALERT_SLACK_USERNAME"
		exit 1
	fi

	if [ -z ${ALERT_SLACK_CHANNEL+x} ]
	  then
		echo "missing variable ALERT_SLACK_CAHNNEL"
		exit 1
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

