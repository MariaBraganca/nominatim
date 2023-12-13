FROM postgres:16

EXPOSE 5432

# Required packages
# ---------------------------------------------------------------------------------------------------------------
ENV POSTGIS_MAJOR=3
ENV POSTGIS_VERSION=3.4.1+dfsg-1.pgdg120+1

RUN apt-get update -qq  \
    && apt-cache showpkg postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR} \
    && apt-get install -y --no-install-recommends \
        ca-certificates gnupg \
        postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}=${POSTGIS_VERSION} \
        postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}-scripts \
    && rm -rf /var/lib/apt/lists/*

# Tuning the PostgreSQL database
# ---------------------------------------------------------------------------------------------------------------
ARG USERNAME=postgres
ARG CONFIG_DIR=/etc/postgresql

COPY --chown=${USERNAME}:${USERNAME} ./postgresql.conf ${CONFIG_DIR}/postgresql.conf

CMD ["-c", "config_file=/etc/postgresql/postgresql.conf"]
