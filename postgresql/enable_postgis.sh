#!/bin/bash
set -e

export DATABASE_USER="nominatim"

psql -v ON_ERROR_STOP=1 --username "$DATABASE_USER" --dbname "$DATABASE_USER" <<-EOSQL
  CREATE EXTENSION postgis;
EOSQL
