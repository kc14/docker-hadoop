#!/bin/bash

echo -e "\n---------------------------------------"

if [[ ! -e /var/lib/hadoop-hdfs/cache/hdfs/dfs/name/current ]]; then
	echo -e	"Initializing HDFS NameNode..."
	/etc/init.d/hadoop-hdfs-namenode init
	rc=$?
	if [ $rc -ne 0 ]; then
		echo -e	"HDFS initialization ERROR!"
	else
		echo -e	"HDFS successfully initialized!"
	fi
fi

echo -e	"Starting NameNode..."
supervisorctl start hdfs-namenode
echo -e	"Starting DataNode..."
supervisorctl start hdfs-datanode

# Wait for NameNode
./wait-for-it.sh "${HOSTNAME}:8020" -t 120
rc=$?
if [ $rc -ne 0 ]; then
    echo -e "\n---------------------------------------"
    echo -e "     HDFS NameNode not ready! Exiting..."
    echo -e "---------------------------------------"
    exit $rc
fi

sudo -E -u hdfs hdfs dfs -mkdir -p /user/hive/warehouse
sudo -E -u hdfs hdfs dfs -mkdir -p /user/hue
sudo -E -u hdfs hdfs dfs -mkdir -p /user/impala
sudo -E -u hdfs hdfs dfs -mkdir -p /tmp
sudo -E -u hdfs hdfs dfs -chmod -R 777 /
