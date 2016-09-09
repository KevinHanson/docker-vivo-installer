FROM tomcat:8.5.5-alpine

ENV VIVO_SRC /opt/vivo
ENV VIVO_HOME /usr/local/vivo/home
ENV WEBAPPS $CATALINA_HOME/webapps

RUN apk update && apk add --no-cache  bash && rm -f /var/cache/apk/*
