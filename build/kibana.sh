#!/usr/bin/env bash
set -e

sed -i "s/@ES_HOST@/$ES_PORT_9200_TCP_ADDR/g" /etc/nginx/sites-available/default
sed -i "s/@ES_PORT@/$ES_PORT_9200_TCP_PORT/g" /etc/nginx/sites-available/default

echo "Connecting Kibana to ElasticSearch backend on $ES_PORT_9200_TCP_ADDR:$ES_PORT_9200_TCP_PORT..."
/usr/sbin/nginx -c /etc/nginx/nginx.conf
