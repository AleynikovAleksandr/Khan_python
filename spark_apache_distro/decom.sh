#!/usr/bin/env bash

# Licensed to the Apache Software Foundation (ASF) ...

set +e
set -x

echo "Asked to decommission"

date | tee -a ${LOG}

WORKER_PID=$(ps -o pid,cmd -C java | grep Executor \
    | tail -n 1 | awk '{ sub(/^[ \t]+/, ""); print }' \
    | cut -f 1 -d " ")

echo "Using worker pid $WORKER_PID"

kill -s SIGPWR ${WORKER_PID}

echo "Waiting for worker pid to exit"
tail --pid=${WORKER_PID} -f /dev/null
sleep 1
date
echo "Done"
date
sleep 1