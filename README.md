# Dockerized Custom VIVO Installer

This git repository is a template for working with and customizing [VIVO](http://vivoweb.org/).  It leverages the use of [Docker](https://www.docker.com/), [docker-compose](https://docs.docker.com/compose/) and VIVO's [three tiered build approach](https://wiki.duraspace.org/display/VIVO/Building+VIVO+in+3+tiers) documented by the VIVO project.  


This repo is my first attempt to contribute to the [VIVO community](https://wiki.duraspace.org/display/VIVO/VIVO) as well as an
attempt to simply make my life easier when trying to develop, test and eventually deploy a VIVO instance.


# Before we get started, please note
- Use the ***mvn package*** life cycle not the **mvn install** (more below)
- This was developed and tested on [Arch Linux](https://www.archlinux.org/) , but should work on most Linux distros
- The Docker image  [g8tor/docker-tomcat8-maven](https://hub.docker.com/r/g8tor/docker-tomcat8-maven/) used in this repo was developed by me
  - Git repo located at [https://github.com/g8tor/docker-tomcat8-maven](https://github.com/g8tor/docker-tomcat8-maven)


- Where possible the docker images are based on official docker images including
 - [Tomcat 8](https://hub.docker.com/_/tomcat/)
 - [Alpine Linux](https://hub.docker.com/_/alpine/)


- The docker-installer subprojects have had their individual pom.xml files modified
  - **home/pom.xml**  
    - during the package phase the assembly now aggregates resources into /home
    - during the package phase the artifact will be extracted to the files directory
  - **solr/pom.xml**
    - during the package phase the artifact will be copied to files/wars
  - **webapp/pom.xml**
    - during the package phase the artifact will be copied to files/wars  



# Requirements (Host Machine)
- [Git](https://git-scm.com/) SCM v2.9.3+
- [Docker](https://www.docker.com/) and [docker-compose](https://docs.docker.com/compose/)
- Java [OpenJDK 7/8](http://openjdk.java.net/), [Oracle Java SE 7/8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
- Apache [Maven](https://maven.apache.org/) v3.3.9+

# Getting Setup

Clone this repository

```[g8tor@arch docker-vivo-installer]$ git clone https://github.com/g8tor/docker-vivo-installer.git```

Change into the resulting directory

```[g8tor@arch docker-vivo-installer]$ cd docker-vivo-installer```

Initialize Submodules (Vitro, Vivo)

```[g8tor@arch docker-vivo-installer]$ git submodule init```

Update the Submodules

```[g8tor@arch docker-vivo-installer]$ git submodule update```

Change into the VIVO directory

```[g8tor@arch VIVO]$ cd VIVO```

Prepare the files directory

```[g8tor@arch VIVO]$ mvn package -s ../docker-installer/docker-settings.xml```

Verify files directory has been initialized  
```[g8tor@arch VIVO]$ tree -L 2 ../files```

***You should see this if yousing the tree command***
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   ../files
   ├── home
   │   ├── config
   │   ├── rdf
   │   └── solr
   └── wars
       ├── vivosolr.war
       └── vivo.war
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
