FROM jboss/wildfly:24.0.0.Final

# Set ENV variables for MariaDB dependency
ENV MARIADB_CONNECTOR_VERSION 2.7.3
ENV MARIADB_CONNECTOR_SHA256 7c823b2f8fdda522a7f76e69cb287482b46247c135c4c44b27b98fb2ae092747

# already USER jboss so no switching necessary

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
    </module>' "${MARIADB_CONNECTOR_VERSION}" > module.xml

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
