#!/bin/bash

JBOSS_HOME=/opt/eap
JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh
JBOSS_MODE=${1:-"standalone"}

function wait_for_server() {
  until `$JBOSS_CLI -c "ls /deployment" &> /dev/null`; do
    sleep 1
  done
}

function run_CLI_CMD () {
  if ! $JBOSS_HOME/bin/jboss-cli.sh --connect --command="$1" & | grep --quiet -E "success"; then
      echo_func "Command failed to execute CLI command \"$1\" properly. Please consult $JBOSS_HOME/standalone/log/server.log  Quiting..." "RED"
      echo_func $($JBOSS_HOME/bin/jboss-cli.sh --connect --command="$1")
      fail_exit_and_kill_JBOSS
  fi
}

function echo_func () {
  if [ "$2" = "RED" ]; then
    echo -e "\e[31m$1\e[0m"
  elif [ "$2" = "YELLOW" ]; then
    echo -e "\e[33m$1\e[0m"
  else
    echo "$1"
  fi
}

function fail_exit_and_kill_JBOSS () {
  kill_jboss
  exit 1
}

function kill_jboss () {
  if [[ $(ps -ef | grep java | grep "jboss-modules.jar" |  awk '{print $2;}') ]]; then
    kill -9 $(ps -ef | grep java | grep "jboss-modules.jar" |  awk '{print $2;}')
  fi
}

echo "=> Starting WildFly server"
$JBOSS_HOME/bin/$JBOSS_MODE.sh &

echo "=> Waiting for the server to boot"
#wait_for_server
sleep 60

echo "=> Executing the commands"
#$JBOSS_CLI --file=`dirname "$0"`/jboss-hardening-configs.cli &
run_CLI_CMD /subsystem=jmx/remoting-connector=jmx:remove
run_CLI_CMD /subsystem=deployment-scanner/scanner=default:write-attribute(name=scan-interval,value=2017)

echo "=> Shutting down WildFly"
if [ "$JBOSS_MODE" = "standalone" ]; then
  $JBOSS_CLI -c ":shutdown" &
else
  $JBOSS_CLI -c "/host=*:shutdown" &
fi

exit 0

