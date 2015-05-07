FROM centos:centos7
MAINTAINER lreeder

######## Helpful utils ########
RUN yum -y install sudo
RUN yum -y install tar
RUN yum -y install wget
########################

######## Download resources for installation ########
WORKDIR /tmp
ADD init-db.sh /tmp/
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u71-b14/jdk-7u71-linux-x64.tar.gz"
RUN wget http://www.us.apache.org/dist/tomcat/tomcat-7/v7.0.61/bin/apache-tomcat-7.0.61.tar.gz
RUN wget http://dev.mysql.com/get/mysql-community-release-el5-5.noarch.rpm
RUN tar xvf jdk-7u71-linux-x64.tar.gz
RUN tar xvf apache-tomcat-7.0.61.tar.gz
########################


######## copy resources to /opt directory ########
WORKDIR /opt
RUN cp /tmp/init-db.sh /opt
RUN cp -R /tmp/jdk1.7.0_71 /opt
RUN cp -R /tmp/apache-tomcat-7.0.61 /opt
RUN cp -R /tmp/mysql-community-release-el5-5.noarch.rpm /opt
RUN chown -R root: /opt/jdk1.7.0_71
RUN chown -R root: /opt/apache-tomcat-7.0.61
RUN chown -R root: /opt/init-db.sh
########################


######## JDK7 ########
RUN alternatives --install /usr/bin/java java /opt/jdk1.7.0_71/bin/java 1
RUN alternatives --install /usr/bin/jar jar /opt/jdk1.7.0_71/bin/jar 1
RUN alternatives --install /usr/bin/javac javac /opt/jdk1.7.0_71/bin/javac 1
RUN echo "JAVA_HOME=/opt/jdk1.7.0_71" >> /etc/environment
########################

######## TOMCAT ########
RUN mv  apache-tomcat-7.0.61 tomcat7
RUN echo "JAVA_HOME=/opt/jdk1.7.0_71" >> /etc/default/tomcat7
EXPOSE 8080
########################

######## MYSQL ########

#**********************************
#* ENV Variables *
#**********************************
#ENV MYSQL_USER root
#ENV MYSQL_PASS password
#ENV MYSQL_CLIENT %
#ENV INITDB true
#ENV MYSQL_DB testdb
RUN yum -y localinstall mysql-community-release-el5-5.noarch.rpm
RUN yum -y install mysql-server
RUN rm -fr /var/cache/*
RUN sh /opt/init-db.sh
#RUN service mysqld stop
EXPOSE 3306

########################

######## ON CONTAINER STARTUP ########
RUN echo "service mysqld start" >> ~/.bashrc
RUN echo "/opt/tomcat7/bin/startup.sh" >> ~/.bashrc
########################

######## Clear /tmp after installation ########
WORKDIR /tmp
RUN rm -rf *.*
########################