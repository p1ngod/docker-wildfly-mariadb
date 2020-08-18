FROM jboss/wildfly:20.0.1.Final

# Set ENV variables for MariaDB dependency
ENV MARIADB_CONNECTOR_VERSION 2.6.2
ENV MARIADB_CONNECTOR_SHA256 f7263dd9c68168304603f3444f8cfeec00ae68eeed711271f4a377f977473d27

# already USER jboss so no switching necessary

RUN mkdir -p ${JBOSS_HOME}/custom \
    && mkdir -p ${JBOSS_HOME}/modules/org/mariadb/main \
    && cd ${JBOSS_HOME}/modules/org/mariadb/main \
    && curl -O https://downloads.mariadb.com/Connectors/java/connector-java-${MARIADB_CONNECTOR_VERSION}/mariadb-java-client-${MARIADB_CONNECTOR_VERSION}.jar \
    && sha256sum mariadb-java-client-${MARIADB_CONNECTOR_VERSION}.jar | grep ${MARIADB_CONNECTOR_SHA256} \
    && printf '<module xmlns="urn:jboss:module:1.3" name="org.mariadb">\n\
        <resources>\n\
            <resource-root path="mariadb-java-client-${MARIADB_CONNECTOR_VERSION}.jar"/>\n\
        </resources>\n\
        <dependencies>\n\
            <module name="javax.api"/>\n\
            <module name="javax.transaction.api"/>\n\
        </dependencies>\n\
    </module>' > module.xml

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
