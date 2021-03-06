#!/bin/bash

# Exit if there is an error
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# If script is executed as an unprivileged user
# Execute it as superuser, preserving environment variables
if [ $EUID != 0 ]; then
    sudo -E "$0" "$@"
    exit $?
fi

# Check all required variables are set
: "${CACHE_LOGS_DIRECTORY:?must be set}"
: "${LOGSTASH_HOST:?must be set}"

# Install apt-transport-https 
/usr/bin/apt -y update
/usr/bin/apt -y install apt-transport-https sudo

# Add elastic apt repo if it does not already exist
if [[ ! -f /etc/apt/sources.list.d/elastic-6.x.list ]]; then
    echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
fi



# Install the key for the elastic repo
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

# Install filebeat
/usr/bin/apt -y update
/usr/bin/apt -y install filebeat

echo "Setting filebeat to ${CACHE_LOGS_DIRECTORY} and  ${LOGSTASH_HOST}"
sed -i "s|CACHE_LOGS_DIRECTORY|${CACHE_LOGS_DIRECTORY}|"    /etc/filebeat/filebeat.yml
sed -i "s|LOGSTASH_HOST|${LOGSTASH_HOST}|"    /etc/filebeat/filebeat.yml

# Start filebeat
service filebeat start
