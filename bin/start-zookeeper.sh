#!/usr/bin/env bash

echo -e "\n---------------------------------------"

if [[ ! -d /var/lib/zookeeper/version-2 ]]; then
	echo -e	"Initiating Zookeeper..."
	/bin/zookeeper-server-initialize
	rc=$?
	if [ $rc -ne 0 ]; then
		echo -e	"Zookeeper initialization ERROR!"
	else
		echo -e	"Zookeeper successfully initialized!"
	fi
fi

echo -e	"Starting Zookeeper..."
supervisorctl start zookeeper-server
./wait-for-it.sh localhost:2181 -t 120
rc=$?
if [ $rc -ne 0 ]; then
    echo -e "\n--------------------------------------------"
    echo -e "      Zookeeper not ready! Exiting..."
    echo -e "--------------------------------------------"
    exit $rc
fi