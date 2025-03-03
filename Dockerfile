ARG WILDFLY_IMAGE=bitnami/wildfly:latest
FROM $WILDFLY_IMAGE

USER root

ENV MARIADB_CONNECTOR_VERSION 3.5.0
ENV MARIADB_CONNECTOR_SHA256 10b777716f1597aed6612abf1985987089fa5446c3bdea2fa4f48a326929f3f5
ENV JBOSS_HOME /opt/bitnami/wildfly
ENV LANG C.UTF-8

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