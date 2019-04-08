#!/bin/env bash

SPARROW_JAR=/sparrow/sparrow-master/target/sparrow-1.0-SNAPSHOT.jar

java -cp $SPARROW_JAR edu.berkeley.sparrow.examples.SimpleBackend
while true
do
  tail -f $SPARROW_HOME/*.log
  sleep 5
done


