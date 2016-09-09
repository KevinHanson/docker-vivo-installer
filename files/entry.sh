#!/bin/sh

export PATH=$JAVA_HOME/bin:$PATH
cd $VIVO_HOME
cp config/example.runtime.properties runtime.properties
cd config
cp example.applicationSetup.n3 applicationSetup.n3
/bin/bash /opt/vivo/files/wait-for-it.sh -t 35 -s mariadb:3306
catalina.sh run
