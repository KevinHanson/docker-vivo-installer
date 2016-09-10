#!/bin/sh

export PATH=$JAVA_HOME/bin:$PATH
# Execute the wait-for-it script to ensure the vivo-maridb instance
# is up, running and accepting connection
/bin/bash /opt/vivo/bin/wait-for-it.sh -t 35 -s mariadb:3306

# Start Tomcat
catalina.sh run
