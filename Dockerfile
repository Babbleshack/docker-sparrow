FROM ubuntu:trusty
#Built using trust for java7

ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

WORKDIR /sparrow

RUN apt update \
        && apt install -y -f wget gnupg unzip openjdk-7-jdk libjansi-java maven \
        && apt install -y -f openssh-server openssh-client apt-transport-https

# Fix the EC parameters error: (ref https://github.com/travis-ci/travis-ci/issues/8503)
RUN wget "https://bouncycastle.org/download/bcprov-ext-jdk15on-158.jar" -O "${JAVA_HOME}"/jre/lib/ext/bcprov-ext-jdk15on-158.jar && \
	perl -pi.bak -e 's/^(security\.provider\.)([0-9]+)/$1.($2+1)/ge' /etc/java-7-openjdk/security/java.security && \
	echo "security.provider.1=org.bouncycastle.jce.provider.BouncyCastleProvider" | tee -a /etc/java-7-openjdk/security/java.security

#Set up ssh keys
RUN rm -rf /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key 
RUN rm -rf /etc/ssh/ssh_host_rsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key 
RUN rm -rf /root/.ssh/id_rsa && ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa 
RUN cp -f /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

RUN wget https://github.com/radlab/sparrow/archive/master.zip \
        && unzip master.zip \
        && rm -rf master.zip 

COPY files/sparrow/etc/sparrow.conf /sparrow/sparrow-master/
COPY ./files/ssh/ssh_config /etc/ssh/
COPY ./files/spark/etc/* /sparrow/spark-sparrow/project/

WORKDIR /sparrow/sparrow-master 
RUN mvn compile \
        && mvn package -Dmaven.test.skip=true
