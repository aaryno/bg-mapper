#!/bin/bash

if [ $# -ne 1 ];
then
    echo "Usage: $0 <base_directory>"
fi

base_dir=$1

docker volume create --driver local \
    --opt type=none \
    --opt device=${base_dir}/web_data \
    --opt o=bind web_data

docker volume create --driver local \
    --opt type=none \
    --opt device=${base_dir}/postgres_data \
    --opt o=bind postgres_data

docker volume create --driver local \
    --opt type=none \
    --opt device=${base_dir}/geoserver_data \
    --opt o=bind geoserver_data