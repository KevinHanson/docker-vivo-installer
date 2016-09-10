FROM tomcat:8.5.5-alpine
ENV SCRIPTS /opt/vivo
ENV VIVO_HOME /usr/local/vivo/home

# Copy required shell scripts
COPY files/*.sh $SCRIPTS/bin/

# Copy VIVO home to default location
COPY files/home $VIVO_HOME

# Complete the installation (configure home directory) as described
# https://wiki.duraspace.org/display/VIVODOC19x/Installing+VIVO#InstallingVIVO-Completing

COPY files/home/config/example.applicationSetup.n3 $VIVO_HOME/config/applicationSetup.n3
COPY files/home/config/example.runtime.properties $VIVO_HOME/runtime.properties

# Copy war files to tomcat webapps directory
COPY files/wars/*.war $CATALINA_HOME/webapps/

# Install aditional required packages for this setup
RUN apk update && apk add bash mysql-client && rm -f /var/cache/apk/*
