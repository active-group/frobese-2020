#!/bin/sh

# Imports dashboard
# exported with curl -XGET 'localhost:5601/api/kibana/dashboards/export?dashboard=<dashboard-id>' > dashboards.json
curl -XPOST localhost:5601/api/kibana/dashboards/import \
    -H 'kbn-xsrf:true' \
    -H 'Content-type:application/json' \
    -d @dashboards.json

