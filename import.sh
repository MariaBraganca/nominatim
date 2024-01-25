#!/bin/bash
set -e

USER_AGENT="nominatim-docker:$NOMINATIM_VERSION"
CURL=("curl" "-L" "-A" "$USER_AGENT" "--fail-with-body")
THREADS=10
IMPORT_COMPLETED="$PROJECT_DIR/import-completed"

if [ -z $PROJECT_DIR ]; then
  export PROJECT_DIR=/srv/nominatim/nominatim-project
  echo "exported PROJECT_DIR=/srv/nominatim/nominatim-project"
fi

if [ -z $OSM_URL ]; then
  echo "Error: OSM_URL is not set."
  echo
  echo "export OSM_URL=https://download.geofabrik.de/europe/germany/berlin-latest.osm.pbf"
  echo "OR provide a different url."
  exit 1
fi

if [ -f $IMPORT_COMPLETED ]; then
  echo "✅ Import completed."
else
  echo "📍 Downloading OSM extract from $OSM_URL..."
  "${CURL[@]}" https://nominatim.org/data/wikimedia-importance.sql.gz -o "$PROJECT_DIR/wikimedia-importance.sql.gz"
  "${CURL[@]}" "$OSM_URL" -C - --create-dirs -o $PROJECT_DIR/data.osm.pbf

  echo "Starting to import data from osm file"
  nominatim import --osm-file $PROJECT_DIR/data.osm.pbf --threads $THREADS
  nominatim index --threads $THREADS
  nominatim admin --check-database
  nominatim freeze

  touch $IMPORT_COMPLETED
fi

tail -f /dev/null
