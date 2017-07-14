FROM openshift/jboss-eap64-openshift:latest

ARG JBOSS_HOME=/opt/eap
ARG SCRIPTS_HOME=${JBOSS_HOME}/scripts
ARG HARDENING_SCRIPT=execute-hardening.sh
ARG HARDENING_CONFIGS=jboss-hardening-configs.cli

RUN mkdir ${SCRIPTS_HOME}
ADD ${HARDENING_SCRIPT} ${SCRIPTS_HOME}
ADD ${HARDENING_CONFIGS} ${SCRIPTS_HOME}

