#!/bin/bash

JBOSS_HOME=/opt/eap
JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh
JBOSS_MODE=${1:-"standalone"}
JBOSS_CONFIG=${2:-"$JBOSS_MODE.xml"}

function wait_for_server() {
    until `$JBOSS_CLI -c`; do
        sleep 1
    done
}

echo "=> Starting WildFly server"
$JBOSS_HOME/bin/$JBOSS_MODE.sh -c $JBOSS_CONFIG

echo "=> Waiting for the server to boot"
#wait_for_server
sleep 60

echo "=> Executing the commands"
$JBOSS_CLI --file=`dirname "$0"`/jboss-hardening-configs.cli

echo "=> Shutting down WildFly"
if [ "$JBOSS_MODE" = "standalone" ]; then
  $JBOSS_CLI -c ":shutdown"
else
  $JBOSS_CLI -c "/host=*:shutdown"
fi

