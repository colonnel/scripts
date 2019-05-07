############################################################
# Dockerfile to build Tomcat8 container images
# Based on Ubuntu
############################################################
FROM ubuntu
MAINTAINER mzol
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install openjdk-8-jdk wget
RUN mkdir /opt/tomcat8
RUN wget http://apache.org/dist/tomcat/tomcat-8/v8.5.29/bin/apache-tomcat-8.5.29.tar.gz -O /tmp/tomcat.tar.gz
RUN cd /tmp && tar xvfz tomcat.tar.gz
RUN cp -Rv /tmp/apache-tomcat-8.5.29/* /opt/tomcat8/
RUN wget http://repo.zabbix.com/zabbix/3.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.4-1+xenial_all.deb
RUN dpkg -i zabbix-release_3.4-1+xenial_all.deb
RUN apt-get -y update
RUN apt-get -y install zabbix-agent
RUN sed -i 's/Server=127.0.0.1/Server=zabbix/g' /etc/zabbix/zabbix_agentd.conf
RUN sed -i 's/ServerActive=127.0.0.1/ServerActive=zabbix/g' /etc/zabbix/zabbix_agentd.conf
# configure tomcat
ADD context.xml /opt/tomcat8/webapps/manager/META-INF/context.xml
ADD tomcat-users.xml /opt/tomcat8/conf/
ADD app_demo.war /opt/tomcat8/webapps
# start tomcat and zabbix
ADD start.sh /usr/bin/
ENV CATALINA_HOME /opt/tomcat8
ENV PATH $PATH:$CATALINA_HOME/bin
EXPOSE 8080
VOLUME "/opt/tomcat8/webapps"
WORKDIR /opt/tomcat8
# check for tomcat
HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail http://localhost:8080 || exit 1
CMD ["/usr/bin/start.sh"]
