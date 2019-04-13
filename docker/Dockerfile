FROM ubuntu:trusty
#Built using trust for java7

ARG SPARROW_URL=https://github.com/radlab/sparrow/archive/master.zip
ARG SPARK_URL=https://github.com/kayousterhout/spark/archive/sparrow.zip
ARG SCALA_URL=https://scala-lang.org/files/archive/scala-2.9.3.deb

ENV SPARROW_CONF=/sparrow/sparrow/etc
#ENV SPARK_CONF=/sparrow/spark/etc
ENV SPARROW_SBIN=/sparrow/sbin
ENV SPARROW_HOME=/sparrow/sparrow-master
ENV SPARK_HOME=/sparrow/spark-sparrow

ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
ENV SCALA_HOME=/usr/bin

#Set hadoop version for spark
ENV SPARK_HADOOP_VERSION=2.9.2

WORKDIR /sparrow

RUN apt update \
        && apt install -y -f wget unzip openjdk-7-jdk libjansi-java maven \
        && apt install -y -f openssh-server openssh-client git

#Install Scala 2.9.3
RUN wget $SCALA_URL -O scala.deb \
	&& dpkg -i scala.deb \
	&& rm -rf scala.deb

#EC Fix: https://stackoverflow.com/questions/47789963/how-to-avoid-ec-parameters-error-using-the-openjdk7-docker-image-and-a-gradle
RUN  wget "https://bouncycastle.org/download/bcprov-ext-jdk15on-158.jar" -O "${JAVA_HOME}"/jre/lib/ext/bcprov-ext-jdk15on-158.jar && \
	perl -pi.bak -e 's/^(security\.provider\.)([0-9]+)/$1.($2+1)/ge' /etc/java-7-openjdk/security/java.security && \
	echo "security.provider.1=org.bouncycastle.jce.provider.BouncyCastleProvider" |  tee -a /etc/java-7-openjdk/security/java.security

#Set up ssh keys
RUN rm -rf /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key 
RUN rm -rf /etc/ssh/ssh_host_rsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key 
RUN rm -rf /root/.ssh/id_rsa && ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa 
RUN cp -f /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

#Get sparrow
RUN wget $SPARROW_URL -O sparrow.zip \
        && unzip sparrow.zip \
        && rm -rf sparrow.zip 

#Get Sparrow-Spark Frontend
RUN wget $SPARK_URL -O spark.zip \
	&& unzip spark.zip \
	&& rm -rf spark.zip
	 

COPY files/sparrow/etc/sparrow.conf $SPARROW_HOME/
COPY files/sparrow/etc/* $SPARROW_CONF/
COPY files/spark/etc/* $SPARK_HOME/project/
COPY ./files/sparrow/sbin/* $SPARROW_SBIN/
COPY ./files/ssh/ssh_config /etc/ssh/

#Compile Sparrow
RUN cd $SPARROW_HOME \
        && mvn compile \
        && mvn package -Dmaven.test.skip=true

ENV SPARROW_JAR=/sparrow/sparrow-master/target/sparrow-1.0-SNAPSHOT.jar

#Compile Spark
RUN cd $SPARK_HOME \
    && mkdir -v $SPARK_HOME/core/lib \
    && cp $SPARROW_JAR $SPARK_HOME/core/lib/ \
	&& sbt/sbt package assembly
