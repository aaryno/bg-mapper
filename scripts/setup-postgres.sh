#!/bin/bash

psql -h localhost -p 5432 -U postgres -c "create database estimates"
psql -h localhost -p 5432 -U postgres -d estimates -c "create extension postgis"

docker run -it --network bgweb -v /Users/aaryn/personal/asdm/data/sampling_grids:/data mdillon/postgis sh -c "shp2pgsql -s 32612 -c -g geom /data/tumamoc_10m public.grid10 | psql -h postgis -U postgres -d estimates"

