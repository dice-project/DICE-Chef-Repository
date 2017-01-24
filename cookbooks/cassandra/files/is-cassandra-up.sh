#!/bin/bash

for i in $(seq $1)
do
  sleep 1
  echo "Checking if Cassandra accepts connections ..."
  cqlsh -e 'show version' && exit 0
done

echo "Cassandra did not start in time."
exit 1
