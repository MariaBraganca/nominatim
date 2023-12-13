FROM postgres:16

EXPOSE 5432

# Required packages
# ---------------------------------------------------------------------------------------------------------------
RUN apt-get update -qq && apt-get install -y \
    postgresql-16-postgis-3 \
    postgresql-contrib-16 postgresql-16-postgis-3-scripts \
&& rm -rf /var/lib/apt/lists/*
