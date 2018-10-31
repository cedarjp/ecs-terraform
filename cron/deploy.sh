#!/usr/bin/env bash

export REPO_PATH="/home/ec2-user/ecsapp";

/usr/bin/pip install -r ${REPO_PATH}/requirements.txt;
cp ${REPO_PATH}/cron/push_notification /etc/cron.d/
