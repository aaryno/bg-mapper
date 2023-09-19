#!/bin/bash

DB_HOST=postgis
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres

DATABASE=estimates
TABLE=grid10

# CREATE WORKSPACE
curl -v -u admin:geoserver -H "Content-type: application/json" -XPOST http://geoserver:8080/geoserver/rest/workspaces -d '
{
  "workspace" : {
    "name": "estimates"
  }
}'

# CREATE DATASTORE
curl -v -u admin:geoserver -H 'Content-type: application/json' -XPOST http://geoserver:8080/geoserver/rest/workspaces/estimates/datastores -d '
{
  "dataStore": {
    "name": "estimates",
    "connectionParameters": {
      "entry": [
        {"@key":"host","$":"'${DB_HOST}'"},
        {"@key":"port","$":"'${DB_PORT}'"},
        {"@key":"database","$":"'${DATABASE}'"},
        {"@key":"user","$":"'${DB_USER}'"},
        {"@key":"passwd","$":"'${DB_PASSWORD}'"},
        {"@key":"dbtype","$":"postgis"}
      ]
    }
  }
}'


BOX=$(psql -t -U postgres -d $DATABASE -h postgis -c "select st_asgeojson(st_extent(geom)) from $TABLE;" | jq '.')
MINX=$(echo $BOX | jq '.coordinates[0][0][0]')
MINY=$(echo $BOX | jq '.coordinates[0][0][1]')
MAXX=$(echo $BOX | jq '.coordinates[0][2][0]')
MAXY=$(echo $BOX | jq '.coordinates[0][2][1]')

curl -v -u admin:geoserver -H 'Content-type: application/json' -XPOST http://geoserver:8080/geoserver/rest/workspaces/estimates/datastores/estimates/featuretypes/ -d '{
  "featureType": {
    "name": "'$TABLE'",
    "nativeName": "'$TABLE'",
    "namespace": {
      "name": "estimates",
      "href": "http://geoserver:8080/geoserver/rest/namespaces/estimates.json"
    },
    "title": "'${TABLE}'",
    "nativeCRS": "EPSG:32612",
    "srs": "EPSG:32612",
    "nativeBoundingBox": {
      "minx": '$MINX',
      "maxx": '$MAXX',
      "miny": '$MINY',
      "maxy": '$MAXY',
      "crs": "EPSG:4326"
    },
    "latLonBoundingBox": {
      "minx": '$MINX',
      "maxx": '$MAXX',
      "miny": '$MINY',
      "maxy": '$MAXY',
      "crs": "EPSG:4326"
    },
    "enabled": true,
    "store": {
      "@class": "dataStore",
      "name": "estimates:estimates",
      "href": "http://geoserver:8080/geoserver/rest/workspaces/estimates/datastores/estimates.json"
    },
  }
}'

# CREATE WORKSPACE
curl -v -u admin:geoserver -H "Content-type: application/json" -XPOST http://geoserver:8080/geoserver/rest/workspaces -d '
{
  "workspace" : {
    "name": "imagery"
  }
}'
