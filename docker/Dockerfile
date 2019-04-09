FROM ubuntu:trusty
#Built using trust for java7

ENV SPARROW_CONF=/sparrow/etc
ENV SPARROW_SBIN=/sparrow/sbin
ENV SPARROW_HOME=/sparrow/sparrow-master

ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

WORKDIR /sparrow

RUN apt update \
        && apt install -y -f wget unzip openjdk-7-jdk libjansi-java maven \
        && apt install -y -f openssh-server openssh-client

#Set up ssh keys
RUN rm -rf /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key 
RUN rm -rf /etc/ssh/ssh_host_rsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key 
RUN rm -rf /root/.ssh/id_rsa && ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa 
RUN cp -f /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

RUN wget https://github.com/radlab/sparrow/archive/master.zip \
        && unzip master.zip \
        && rm -rf master.zip 

COPY files/sparrow/etc/sparrow.conf $SPARROW_HOME/
COPy files/sparrow/etc/* $SPARROW_CONF/
COPY ./files/ssh/ssh_config /etc/ssh/
# Add init scripts
COPY ./files/sparrow/sbin/* $SPARROW_SBIN/

RUN cd /sparrow/sparrow-master \
        && mvn compile \
        && mvn package -Dmaven.test.skip=true

ENV SPARROW_JAR=/sparrow/sparrow-master/target/sparrow-1.0-SNAPSHOT.jar
