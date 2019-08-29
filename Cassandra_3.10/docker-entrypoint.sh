#!/bin/bash

# Global variables
CASSANDRA_HOME=/home/apache-cassandra-3.10

if [ $CASSANDRA_HOME == "None" ]
then
	echo "CASSANDRA_HOME can not set."
	exit
fi
if [ $CASSANDRA_CONFIG_FILE_PATH == "None" ]
then
	echo "CASSANDRA_CONFIG_FILE_PATH can not set."
	exit
fi

if [ -f /home/CONFIG_OK ]
then
	echo "Already Configured"
else
	# JAVA Configuration
	JAVAHOME=`alternatives --list  | grep jre_openjdk | awk '{print $3}'`
	JAVAHOME1=${JAVAHOME::-4}
	echo "export JAVA_HOME=$JAVAHOME1" >> /root/.bashrc
	echo "export COMPRESSION=NONE" >> /root/.bashrc
	echo "JAVA_HOME has been set."

	# Cassandra Configuration
	rm -rf $CASSANDRA_HOME/conf
	cp -r $CASSANDRA_CONFIG_FILE_PATH $CASSANDRA_HOME/conf
	echo "Cassandra has been configured."

	sed -i '/# prefer unqualified "python" if suitable:/a pyver=2.7' $CASSANDRA_HOME/bin/cqlsh
	
	touch /home/CONFIG_OK
	echo "Configuration OK"
fi

# Source
source /root/.bashrc

# Cassandrayı çalıştır
cd $CASSANDRA_HOME
sh ./bin/cassandra -R

exec /bin/bash
