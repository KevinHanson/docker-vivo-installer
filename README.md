# Dockerized Custom VIVO Installer

This git repository is a template for working with and customizing [VIVO](http://vivoweb.org/).  It leverages the use of [Docker](https://www.docker.com/), [docker-compose](https://docs.docker.com/compose/) and VIVO's [three tiered](https://wiki.duraspace.org/display/VIVO/Building+VIVO+in+3+tiers) build documented by the VIVO project. The resulting dockerized project contains two dependent images suitable for **development and testing** of VIVO.

This repo is my first attempt to contribute to the [VIVO community](https://wiki.duraspace.org/display/VIVO/VIVO) and not meant for or ready for use in a production environment. Use of this repo is at your ** OWN RISK** and comes with the inherent security issues when adopting newer technologies like Docker.


# Docker Images Used
Image Name | Base Docker Image | Tag | Dependency| Provides
--- | --- | --- | --- | ---
vivo-mariadb | [bitnami/mariadb](https://hub.docker.com/r/bitnami/mariadb/) | `latest` | |MariaDB
vivo-tomcat | [tomcat:8.5.5-alpine](tomcat:8.5.5-alpine) | `latest` | vivo-mariadb|[Tomcat 8.5.5](8.5.5) and [OpenJDK 8 ](http://openjdk.java.net/install/)


# Attribution
I can not take credit for all of this. I make liberal use of resources available on both [GitHub]() and [Docker HUB]() to make this image possible. In addition to the docker images listed above, I used the work of @vishnubob [vishnubob/wait-for-it]() repository.

The [wait-for-it.sh](files/wait-for-it.sh) file (in the files directory) was modified to add the -t flag to the timeout command for use with the alpine Linux based tomcat image.

# About this repository
- Developed and tested on [Arch Linux](https://www.archlinux.org/) , (should should work on most Linux distros)
- Where possible the docker images are based on official docker images including

# Modifications to the default VIVO installer
The docker-installer subprojects have had their individual pom.xml files modified

File | Modification(s)
--- | ---
**home/pom.xml** | <ul><li> during the package phase the assembly now aggregates resources into /home</li><li>during the package phase the artifact will be extracted to the files directory</li>
**solr/pom.xml** | <ul><li>during the package phase the artifact will be copied to files/wars</li></ul>
**webapp/pom.xml** | <ul><li>during the package phase the artifact will be copied to files/wars</li></ul>  



# Host Machine Requirements
- [Git](https://git-scm.com/) SCM v2.9.3+
- [Docker](https://www.docker.com/) and [docker-compose](https://docs.docker.com/compose/)
- Java [OpenJDK 7/8](http://openjdk.java.net/), [Oracle Java SE 7/8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
- Apache [Maven](https://maven.apache.org/) v3.3.9+

# Enough Already Lets Get Started

Clone this repository

```[g8tor@swamp ~]$ git clone https://github.com/g8tor/docker-vivo-installer.git docker-vivo```

Change into the resulting directory

```[g8tor@swamp ~]$ cd docker-vivo```

Initialize Submodules (Vitro, Vivo)

```[g8tor@swamp docker-vivo]$ git submodule init```

Update the Submodules

```[g8tor@swamp docker-vivo]$ git submodule update```

Change into the VIVO directory

```[g8tor@swamp docker-vivo]$ cd VIVO```

Prepare the files directory

```[g8tor@swamp VIVO]$ mvn package -s ../docker-installer/docker-settings.xml```

Verify files directory has been initialized  
```[g8tor@swamp VIVO]$ tree -L 2 ../files```

***You should see this if you sing the tree command***
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../files
├── entry.sh
├── home
│   ├── config
│   ├── rdf
│   └── solr
├── wait-for-it.sh
└── wars
    ├── vivosolr.war
    └── vivo.war
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# The Moment of Truth

Change directory back to docker-vivo

```[g8tor@swamp VIVO]$ cd ../```

# Start the docker instances using docker-compose

```[g8tor@swamp docker-vivo]$ docker-compose up ```

After a bunch of text flying past you screen you should see something like this

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
vivo-mariadb | 2016-09-09 12:46:52 139930325752576 [Note] InnoDB: Online DDL : End of applying row log
vivo-mariadb | 2016-09-09 12:46:52 139930325752576 [Note] InnoDB: Online DDL : Completed
vivo-tomcat | 09-Sep-2016 12:48:19.270 INFO [localhost-startStop-1] org.apache.catalina.startup.HostConfig.deployWAR Deployment of web application archive /usr/local/tomcat/webapps/vivo.war has finished in 91,870 ms
vivo-tomcat | 09-Sep-2016 12:48:19.281 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler [http-nio-8080]
vivo-tomcat | 09-Sep-2016 12:48:19.294 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler [ajp-nio-8009]
vivo-tomcat | 09-Sep-2016 12:48:19.307 INFO [main] org.apache.catalina.startup.Catalina.start Server startup in 95835 ms

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Verify the mariadb/mysql image is up and running and that the default vitrodb was created.

```[g8tor@swamp docker-vivo]$ docker exec -it vivo-mariadb mysql -p vitrodb```

When prompted enter the default password (vitrodbPassword), if successful you should see this

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Enter password:
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 28
Server version: 10.1.14-MariaDB Source distribution

Copyright (c) 2000, 2016, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [vitrodb]>

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Next exit and verify that the vivo-tomcat instance can connect to the vivo-mariadb instance. (Although, if the above command completed successfully you can be sure that the vivo-tomcat container connected and created the default vitrodb.)

```[g8tor@swamp docker-vivo]$ docker exec -it vivo-tomcat mysql -h mariadb -p vitrodb```

Enter the password when prompted and you should see

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 25
Server version: 10.1.14-MariaDB Source distribution

Copyright (c) 2000, 2016, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [vitrodb]>
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# FINALLY

Open your browser and navigate to http://localhost:8080/vivo 

# CONGRATS
You have successfully deployed your Dockerized VIVO Development environment.


--g8tor@swamp
