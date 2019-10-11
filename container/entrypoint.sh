#!/usr/bin/env bash

set -e

BROKER_HOME=/var/lib/
CONFIG_PATH=$BROKER_HOME/etc
export BROKER_HOME OVERRIDE_PATH CONFIG_PATH

echo CREATE_ARGUMENTS=${CREATE_ARGUMENTS}
if ! [ -f ./etc/broker.xml ]; then
    /opt/activemq-artemis/bin/artemis create ${CREATE_ARGUMENTS} .
else
    echo "broker already created, ignoring creation"
fi

cp -rf /container/artemis-instance/* ${BROKER_HOME}artemis-instance/etc/

exec ./bin/artemis "$@"
