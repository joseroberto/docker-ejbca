ARG DINAMO_FILE=dinamo-3.2.18-1.x86_64
ARG EJBCA_FILE=ejbca_ce_6_3_1_1
ARG JBOSS_FILE=jboss-as-7.1.1.Final
# written by Benoit Sarda and adapted by Jose Roberto
# ejbca container. uses jroberto/jboss by copy/paste.
#
#   Jose Roberto <joseroberto@dinamonetworks.com>
#
FROM centos:centos7.2.1511
MAINTAINER Jose Roberto <joseroberto@dinamonetworks.com>

# expose
EXPOSE 8080 8442 8443

# arguments
ARG DINAMO_FILE
ARG EJBCA_FILE
ARG JBOSS_FILE

# declare vars
ENV JBOSS_HOME=/opt/$JBOSS_FILE \
	APPSRV_HOME=/opt/$JBOSS_FILE \
	EJBCA_HOME=/opt/$EJBCA_FILE \
    # db vars
	DB_USER=ejb_user \
	DB_PASSWORD=P@ssw0rd! \
	DB_URL=jdbc:postgresql://banco:5432/ejbca \
	DB_DRIVER=org.postgresql.Driver \
	DB_NAME=ejbca \
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
	WEB_SELFREG=true \
	# pkcs11
	DFENCE_PKCS11_IP=200.202.33.23 \
	DFENCE_PKCS11_USER=ejbcauser \
	DFENCE_PKCS11_ENCRYPTED=1 \
	DFENCE_PKCS11_AUTO_RECONNECT=1 \
	DFENCE_PKCS11_HANDLE_CACHE_TIMEOUT=1 

WORKDIR /opt

# add files
ADD ["ejbca_ce_6_3_1_1.zip", \
	"postgresql-9.1-903.jdbc4.jar", \
	"ejbcainit.sh", \
	"dinamo.conf", \
	"jbossinit.sh", \
	"dbinit.sh", \
	"stop.sh", \
	"init.sh", \
	"jboss-modules.jar", \
	"/opt/"]

# install prereq

RUN	groupadd ejbca && useradd ejbca -g ejbca 

RUN yum install -y wget unzip which net-tools java-1.7.0-openjdk java-1.7.0-openjdk-devel ant ant-optional

RUN	rpm -ivh https://hsm.dinamonetworks.com/bin/client/releases/linux/x64/$DINAMO_FILE.rpm && \
	wget https://download.jboss.org/jbossas/7.1/$JBOSS_FILE/$JBOSS_FILE.zip 

RUN	unzip ${JBOSS_FILE}.zip && unzip ${EJBCA_FILE}.zip && rm ${JBOSS_FILE}.zip && rm ${EJBCA_FILE}.zip

RUN	chmod 750 /opt/init.sh && chmod 750 /opt/dbinit.sh && chmod 750 /opt/jbossinit.sh && chmod 750 /opt/ejbcainit.sh && chmod 750 /opt/stop.sh && \
	sed -i 's/jboss.bind.address.management:127.0.0.1/jboss.bind.address.management:0.0.0.0/' $APPSRV_HOME/standalone/configuration/standalone.xml

RUN cd /opt/ejbca_ce_6_3_1_1/modules/clientToolBox && ant

CMD ["/opt/init.sh"]
