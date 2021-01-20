FROM josh5/lancache-bundle:latest
LABEL maintainer="Supermillhouse"

# This Dockerfile is designed to simply pull together the docker-compose
# lancache project into a single image along with zeropingheroes/lancache-filebeat
# to work with the zeropingheroes ELK repo.
# It is not supposed to over complicate things or re-invent the wheel.
# As such, it will be based on josh5 lancache-bundle docker image and will install
# filebeat on top.
#
# Designed for personal home use only and is by no means optimised.
#

# Install filebeat
#RUN \
#    echo "**** Install filebeat ****" \
#        && git clone --depth=1 https://github.com/zeropingheroes/lancache-filebeat /opt/lancache-filebeat
        
# Copy in any local config files
COPY overlay/ /

# logstash env variables
ENV \
    LOGSTASH_HOST="elk:5044" \
    CACHE_LOGS_DIRECTORY="/var/log/nginx" \ 
    \
# IP address listed below NEEDS to be the same as the host IP
    \
    DNS_BIND_IP=192.168.2.7 \
    LANCACHE_IP=192.168.2.7

VOLUME ["/var/log", "/data/cache", "/var/www"]

WORKDIR /var/log/
