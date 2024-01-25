FROM postgres:14-bookworm

EXPOSE 5432

# Required packages
# ---------------------------------------------------------------------------------------------------------------
ENV DEBIAN_FRONTEND=noninteractive

ENV POSTGIS_MAJOR=3
ENV POSTGIS_VERSION=3.4.1+dfsg-1.pgdg120+1

RUN apt-get update -qq  \
    && apt-cache showpkg postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR} \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}=${POSTGIS_VERSION} \
        postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}-scripts \
    && rm -rf /var/lib/apt/lists/*

# Create Roles
# ---------------------------------------------------------------------------------------------------------------
ARG DOCKER_ENTRYPOINT_DIR=/docker-entrypoint-initdb.d

RUN mkdir -p $DOCKER_ENTRYPOINT_DIR
COPY ./create_roles.sh $DOCKER_ENTRYPOINT_DIR/create_roles.sh

# Tuning the PostgreSQL database
# ---------------------------------------------------------------------------------------------------------------
COPY ./postgresql.conf /etc/postgresql/postgresql.conf

CMD ["-c", "config_file=/etc/postgresql/postgresql.conf"]
