#!/bin/env bash
SPARROW_JAR=/sparrow/sparrow-master/target/sparrow-1.0-SNAPSHOT.jar

java -XX:+UseConcMarkSweepGC -cp $SPARROW_JAR edu.berkeley.sparrow.daemon.SparrowDaemon -c $SPARROW_JAR
