#!/bin/bash
set -e

# export DATABASE_USER="postgres"

psql -v ON_ERROR_STOP=1 --username "$DATABASE_USER" --dbname "$DATABASE_USER" <<-EOSQL
  CREATE EXTENSION postgis;
  CREATE ROLE "www-data" LOGIN;
EOSQL
