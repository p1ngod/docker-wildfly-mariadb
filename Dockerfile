ARG WILDFLY_IMAGE=bitnami/wildfly:30
FROM $WILDFLY_IMAGE

USER root

ENV MARIADB_CONNECTOR_VERSION 3.3.3
ENV MARIADB_CONNECTOR_SHA256 89d71a6ffd800c032b23e588108688d391631f0aba962ba2381cc82cb111b796
ENV JBOSS_HOME /opt/bitnami/wildfly

RUN install_packages curl \
    && mkdir -p ${JBOSS_HOME}/custom \
    && mkdir -p ${JBOSS_HOME}/modules/org/mariadb/main \
    && cd ${JBOSS_HOME}/modules/org/mariadb/main \
    && curl -O https://downloads.mariadb.com/Connectors/java/connector-java-${MARIADB_CONNECTOR_VERSION}/mariadb-java-client-${MARIADB_CONNECTOR_VERSION}.jar \
    && sha256sum mariadb-java-client-${MARIADB_CONNECTOR_VERSION}.jar | grep ${MARIADB_CONNECTOR_SHA256} \
    && printf '<module xmlns="urn:jboss:module:1.3" name="org.mariadb">\n\
        <resources>\n\
            <resource-root path="mariadb-java-client-%s.jar"/>\n\
        </resources>\n\
        <dependencies>\n\
            <module name="javax.api"/>\n\
            <module name="javax.transaction.api"/>\n\
        </dependencies>\n\
    </module>' "${MARIADB_CONNECTOR_VERSION}" > module.xml \
    && mkdir /data \
    && chown 1001:1001 /data \
    && rm /opt/bitnami/wildfly/standalone/deployments/*.jar

USER 1001

ADD /standalone.xml /bitnami/wildfly/configuration/