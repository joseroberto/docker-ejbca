# written by Benoit Sarda and adapted by Jose Roberto
# ejbca container. uses jroberto/jboss by copy/paste.
#
#   Jose Roberto <joseroberto@dinamonetworks.com>
#
FROM centos:centos7.2.1511
MAINTAINER Jose Roberto <joseroberto@dinamonetworks.com>

# expose
EXPOSE 8080 8442 8443

# declare vars
ENV JBOSS_HOME=/opt/jboss-as-7.1.1.Final \
	APPSRV_HOME=/opt/jboss-as-7.1.1.Final \
	EJBCA_HOME=/opt/ejbca_ce_6_3_1_1 \
    # db vars
	DB_USER=ejb_user \
	DB_PASSWORD=P@ssw0rd! \
	DB_URL=jdbc:postgresql://banco:5432/ejbca \
	DB_DRIVER=org.postgresql.Driver \
	DB_NAME=postgres \
    # ebjca configs
	EJBCA_CLI_USER=ejbca \
	EJBCA_CLI_PASSWORD=ejbca \
	EJBCA_KS_PASS=foo123 \
    # ca config
	CA_NAME=DinamoCA \
	CA_DN=CN=DinamoCA,O=Engenharia,C=BR \
	CA_KEYSPEC=4096 \
	CA_KEYTYPE=RSA \
	CA_SIGNALG=SHA256WithRSA \
	CA_VALIDITY=3650 \
    # web config
	WEB_SUPERADMIN=DinamoAdmin \
	WEB_JAVA_TRUSTPASSWORD=changeit \
	WEB_HTTP_PASSWORD=serverpwd \
	WEB_HTTP_HOSTNAME=localhost \
	WEB_HTTP_DN=CN=localhost,O=Engenharia,C=BR \
	WEB_SELFREG=true

# add files
ADD [	"jboss-as-7.1.1.Final.tar.gz", \
	"ejbca_ce_6_3_1_1.tar.gz", \
	"postgresql-9.1-903.jdbc4.jar", \
	"ejbcainit.sh", \
	"jbossinit.sh", \
	"dbinit.sh", \
	"stop.sh", \
	"init.sh", \
	"jboss-modules.jar", \
	"/opt/"]



# install prereq
RUN yum install -y net-tools java-1.7.0-openjdk java-1.7.0-openjdk-devel ant ant-optional && \
	groupadd ejbca && useradd ejbca -g ejbca && \
	chmod 750 /opt/init.sh && chmod 750 /opt/dbinit.sh && chmod 750 /opt/jbossinit.sh && chmod 750 /opt/ejbcainit.sh && chmod 750 /opt/stop.sh && \
	sed -i 's/jboss.bind.address.management:127.0.0.1/jboss.bind.address.management:0.0.0.0/' $APPSRV_HOME/standalone/configuration/standalone.xml

CMD ["/opt/init.sh"]
