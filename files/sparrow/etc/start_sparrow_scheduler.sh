#!/bin/env bash
SPARROW_HOME=/sparrow/sparrow-master
SPARROW_JAR=/sparrow/sparrow-master/target/sparrow-1.0-SNAPSHOT.jar
SPARROW_CONF=/sparrow/sparrow-master/sparrow.conf
java -XX:+UseConcMarkSweepGC -cp $SPARROW_JAR edu.berkeley.sparrow.daemon.SparrowDaemon -c $SPARROW_JAR &
while true
do
  tail -f $SPARROW_HOME/*.log
  sleep 5
done


