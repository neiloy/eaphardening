FROM openshift/jboss-eap64-openshift:latest

ARG JBOSS_HOME=/opt/eap
ARG SCRIPTS_HOME=${JBOSS_HOME}/scripts
ARG HARDENING_SCRIPT=execute-hardening.sh
ARG HARDENING_CONFIGS=jboss-hardening-configs.cli

RUN mkdir ${SCRIPTS_HOME}
ADD ${HARDENING_SCRIPT} ${SCRIPTS_HOME}
ADD ${HARDENING_CONFIGS} ${SCRIPTS_HOME}

RUN sh ${SCRIPTS_HOME}/${HARDENING_SCRIPT}
USER root
RUN chgrp -R 0 ${JBOSS_HOME} && chmod -R ago+rwx ${JBOSS_HOME}
USER 185

