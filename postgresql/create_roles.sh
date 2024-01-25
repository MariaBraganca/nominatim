#!/bin/bash
set -e

if [ -z "$POSTGRES_PASSWORD" ]; then
    echo "Error: POSTGRES_PASSWORD is not set."
    echo
    echo 'export POSTGRES_PASSWORD="HSnDDgFtyW9fyFI"'
    echo "OR generate new value."
    exit 1
fi

psql -v ON_ERROR_STOP=1 -v password_to_save=$POSTGRES_PASSWORD <<-EOSQL
  CREATE ROLE nominatim WITH SUPERUSER LOGIN ENCRYPTED PASSWORD :'password_to_save';
  CREATE ROLE "www-data" LOGIN;
EOSQL
