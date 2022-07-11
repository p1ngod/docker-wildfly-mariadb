ARG WILDFLY_IMAGE=bitnami/wildfly:latest
FROM $WILDFLY_IMAGE

USER root

ENV MARIADB_CONNECTOR_VERSION 3.0.6
ENV MARIADB_CONNECTOR_SHA256 977ca7980b777b5aa8d32678204296a108f3eacbc4f210887e39b19869fad0d3
ENV JBOSS_HOME /opt/bitnami/wildfly

RUN mkdir -p ${JBOSS_HOME}/custom \
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