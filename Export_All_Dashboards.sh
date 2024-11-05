#!/bin/bash

set -o errexit
set -o pipefail

HOST="http://grafana.domain.local:3000"
FULLURL="http://grafana.domain.local:3000"
KEY="TOKEN"

set -o nounset

echo "Exporting Grafana dashboards from $HOST"
rm -rf dashboards
mkdir -p dashboards
for dash in $(curl -H "Authorization: Bearer $KEY" -s "$FULLURL/api/search?query=&" | jq -r '.[] | select(.type == "dash-db") | .uid'); do
        curl -H "Authorization: Bearer $KEY" -s "$FULLURL/api/dashboards/uid/$dash" | jq -r . > dashboards/${dash}.json
        slug=$(cat dashboards/${dash}.json | jq -r '.meta.slug')
        mv dashboards/${dash}.json dashboards/${dash}-${slug}.json
done
