#!/bin/bash
/etc/init.d/ssh start
java -cp $SPARROW_JAR edu.berkeley.sparrow.examples.SimpleBackend
while true
do
  tail -f $SPARROW_HOME/*.log
  sleep 5
done


