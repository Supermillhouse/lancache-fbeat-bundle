#!/bin/bash

# Exit if there is an error
set -e

if [[ ! -f /etc/apt/sources.list.d/elastic-7.x.list ]]; then
# Check all required variables are set
: "${CACHE_LOGS_DIRECTORY:?must be set}"
: "${LOGSTASH_HOST:?must be set}"

# Install apt-transport-https 
/usr/bin/apt -y update
/usr/bin/apt -y install apt-transport-https sudo nano net-tools

# Add elastic apt repo if it does not already exist

echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

# Install the key for the elastic repo
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

# Install filebeat
/usr/bin/apt -y update
/usr/bin/apt -y install filebeat

##echo "Setting filebeat to ${CACHE_LOGS_DIRECTORY} and  ${LOGSTASH_HOST}"
##sed -i "s|CACHE_LOGS_DIRECTORY|${CACHE_LOGS_DIRECTORY}|"    /etc/filebeat/filebeat.yml
##sed -i "s|LOGSTASH_HOST|${LOGSTASH_HOST}|"    /etc/filebeat/filebeat.yml

# Start filebeat
##service filebeat start
fi
