#!/bin/bash

OPENTSDB_HOME=/home/opentsdb-2.3.0
KAFKA2OPENTSDB_HOME=/home/Kafka2OpenTSDB

if [ -f /home/CONFIG_OK ]
then
	echo "Already configured."
else
	# OpenTSDB Ayarlarını Yap
	rm -rf $OPENTSDB_HOME/opentsdb.conf
	rm -rf $OPENTSDB_HOME/src/opentsdb.conf
	cp $OPENTSDB_CONFIG_FILE_PATH $OPENTSDB_HOME/opentsdb.conf
	cp $OPENTSDB_CONFIG_FILE_PATH $OPENTSDB_HOME/src/opentsdb.conf

	touch /home/CONFIG_OK
	echo "Configuration OK"
fi

# OpenTSBD arayüzü çalıştır
if [ $START_OPENTSDB -eq 1 ]
then
	cd $OPENTSDB_HOME
	nohup ./build/tsdb tsd &
	echo "OpenTSDB Started"
fi

sleep 1m

if [ $LOAD_TEST_DATA -eq 1 ]
then
	cd $OPENTSDB_HOME
	./build/tsdb import --auto-metric $CONFIG_FILE_PATH/data/test-data.txt.gz
fi

exec /bin/bash
