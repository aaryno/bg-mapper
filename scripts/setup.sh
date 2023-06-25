#!/bin/bash

pip install fastapi
pip install "uvicorn[standard]"
pip install sqlalchemy
pip install databases
pip install psycopg2-binary
pip install asyncpg

psql -h localhost -p 5432 -U postgres -c "create database estimates"
psql -h localhost -p 5432 -U postgres -d estimates -c "create extension postgis"