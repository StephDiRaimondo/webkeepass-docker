FROM alpine:latest
MAINTAINER Stéphane DI RAIMONDO

RUN mkdir /keepass
VOLUME /keepass

ADD start.sh /
RUN chmod +x /start.sh

EXPOSE 5001
