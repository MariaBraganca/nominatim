FROM postgres:16

EXPOSE 5432

# Required packages
# ---------------------------------------------------------------------------------------------------------------
ENV POSTGIS_MAJOR=3
ENV POSTGIS_VERSION=3.4.1+dfsg-1.pgdg120+1

RUN apt-get update -qq  \
    && apt-cache showpkg postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR} \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}=${POSTGIS_VERSION} \
        postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}-scripts \
    && rm -rf /var/lib/apt/lists/*

# Enabling PostGIS
# ---------------------------------------------------------------------------------------------------------------
ARG DOCKER_ENTRYPOINT_DIR=/docker-entrypoint-initdb.d

RUN mkdir -p $DOCKER_ENTRYPOINT_DIR
COPY ./enable_postgis.sh $DOCKER_ENTRYPOINT_DIR/enable_postgis.sh

# Tuning the PostgreSQL database
# ---------------------------------------------------------------------------------------------------------------
ARG USERNAME=postgres
ARG CONFIG_DIR=/etc/postgresql

COPY --chown=${USERNAME}:${USERNAME} ./postgresql.conf ${CONFIG_DIR}/postgresql.conf

CMD ["-c", "config_file=/etc/postgresql/postgresql.conf"]
