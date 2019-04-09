#!/bin/bash
SPARROW_JAR=/sparrow/sparrow-master/target/sparrow-1.0-SNAPSHOT.jar
java -XX:+UseConcMarkSweepGC -cp $SPARROW_JAR edu.berkeley.sparrow.daemon.SparrowDaemon -c $SPARROW_JAR &
java -cp $SPARROW_JAR edu.berkeley.sparrow.examples.SimpleFrontend
while true
do
  tail -f $SPARROW_HOME/*.log
  sleep 5
done


