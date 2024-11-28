#!/bin/bash

# Run loop to start application 10 times
for i in {1..10} loop
do
    echo "Starting application $i"
    java -jar target/demo-0.0.1-SNAPSHOT.jar ./target/classes/application.properties > log_$i.txt &
done