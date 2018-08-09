#!/bin/sh
#wget http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz
#wget http://downloads.sourceforge.net/project/ejbca/ejbca6/ejbca_6_3_1_1/ejbca_ce_6_3_1_1.zip
#mv ejbca_ce_6_3_1_1.zip ejbca_ce_6_3_1_1.tar.gz

docker build -t jroberto/ejbca .
docker tag jroberto/ejbca jroberto/ejbca:latest
docker tag jroberto/ejbca jroberto/ejbca:1.0
