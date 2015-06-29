#!/usr/bin/env bash

set -eo pipefail

CONF_FILE="/opt/kibana/config/kibana.yml"
ES_URL="http://${ES_PORT_9200_TCP_ADDR}:${ES_PORT_9200_TCP_PORT}"

sed -i "s;^elasticsearch_url:.*;elasticsearch_url: \"${ES_URL}\";" ${CONF_FILE}
if [ -n "${KIBANA_INDEX}" ]; then
  echo "setting index!"
  sed -i 's;^kibana_index:.*;kibana_index: ${KIBANA_INDEX};' ${CONF_FILE}
fi

unset HOST
unset PORT

exec /opt/kibana/bin/kibana
