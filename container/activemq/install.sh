#!/usr/bin/env bash
set -e
ACTIVEMQ_ARTEMIS_SRC="/container/activemq"
apt update
apt install -y logrotate nano

# create activemq group and user
groupadd -g 1000 -r ${ARTEMIS_USER} && useradd -r -u 1000 -g ${ARTEMIS_USER} ${ARTEMIS_USER} \
 && apt-get -qq -o=Dpkg::Use-Pty=0 update && \
    apt-get -qq -o=Dpkg::Use-Pty=0 install -y --no-install-recommends \
    libaio1=0.3.110-3 && \
    rm -rf /var/lib/apt/lists/*


echo '%artemis ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
usermod -aG sudo ${ARTEMIS_USER}

# download tar.gz binary
cd /tmp
wget "https://www-eu.apache.org/dist/activemq/activemq-artemis/${ACTIVEMQ_ARTEMIS_VERSION}/apache-artemis-${ACTIVEMQ_ARTEMIS_VERSION}-bin.tar.gz"
wget "https://www.apache.org/dist/activemq/activemq-artemis/${ACTIVEMQ_ARTEMIS_VERSION}/apache-artemis-${ACTIVEMQ_ARTEMIS_VERSION}-bin.tar.gz.sha512"
sha512sum -c "apache-artemis-${ACTIVEMQ_ARTEMIS_VERSION}-bin.tar.gz.sha512"

tar zxf "apache-artemis-${ACTIVEMQ_ARTEMIS_VERSION}-bin.tar.gz"
mv "apache-artemis-${ACTIVEMQ_ARTEMIS_VERSION}" /opt/

chown -R ${ARTEMIS_USER}:${ARTEMIS_USER} "/opt/apache-artemis-${ACTIVEMQ_ARTEMIS_VERSION}"
ln -sf "/opt/apache-artemis-${ACTIVEMQ_ARTEMIS_VERSION}" "${ACTIVEMQ_HOME}"

mkdir  /var/lib/artemis-instance && chown -R ${ARTEMIS_USER}:${ARTEMIS_USER} /var/lib/artemis-instance

# cleanup temp files
rm -rf /tmp/*
#rm -rf "${ACTIVEMQ_HOME}"/examples

# Configure LogRotate
cp -rf "${ACTIVEMQ_ARTEMIS_SRC}"/logrotate/activemq /etc/logrotate.d/activemq


