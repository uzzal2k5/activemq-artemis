##
# image: uzzal2k5/activemq-artemis
##

FROM uzzal2k5/java:8.192.12
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV ACTIVEMQ_HOME /opt/activemq-artemis
ENV ACTIVEMQ_ARTEMIS_VERSION 2.10.1

ENV ARTEMIS_USER artemis
ENV ARTEMIS_PASSWORD brewski01
ENV ANONYMOUS_LOGIN false
ENV CREATE_ARGUMENTS --user ${ARTEMIS_USER} --password ${ARTEMIS_PASSWORD} --silent --http-host 0.0.0.0 --relax-jolokia


COPY container /container

RUN find /container -type f -name "*.sh" -exec chmod +x {} + && \
    /container/activemq/install.sh && \
    rm -rf /container/activemq

USER artemis
WORKDIR ${ACTIVEMQ_HOME}
# Web Server
EXPOSE 8161 \
# JMX Exporter
    9404 \
# Port for CORE,MQTT,AMQP,HORNETQ,STOMP,OPENWIRE
    61616 \
# Port for HORNETQ,STOMP
    5445 \
# Port for AMQP
    5672 \
# Port for MQTT
    1883 \
#Port for STOMP
    61613
# Expose some outstanding folders
VOLUME ["/var/lib/artemis-instance"]
WORKDIR /var/lib/artemis-instance

ENTRYPOINT ["/container/entrypoint.sh"]
CMD ["run"]



