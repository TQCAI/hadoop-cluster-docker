#!/bin/bash

# the default node number is 3
N=${1:-3}


# start hadoop master container
IMAGE=tqc/hadoop:3.0
docker rm -f hadoop-master &> /dev/null
sleep 1
echo "start hadoop-master container..."
docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
                --name hadoop-master \
                --hostname hadoop-master \
                ${IMAGE}


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	docker rm -f hadoop-slave$i &> /dev/null
	sleep 1
	echo "start hadoop-slave$i container..."
	docker run -itd \
	                --net=hadoop \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
	                ${IMAGE}
	sleep 1
	i=$(( $i + 1 ))
done 

# get into hadoop master container
docker exec  hadoop-master bash start-hadoop.sh
