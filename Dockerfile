FROM debian:bookworm

EXPOSE 8080

# Required packages
# ---------------------------------------------------------------------------------------------------------------
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -y \
    # Build tools
    build-essential cmake g++ libboost-dev libboost-system-dev \
    libboost-filesystem-dev libexpat1-dev zlib1g-dev \
    libbz2-dev libpq-dev liblua5.4-dev nlohmann-json3-dev \
    libproj-dev libicu-dev \
    # PHP
    php-cli php-pgsql php-intl \
    # Python 3
    python3-dev python3-dotenv python3-psycopg2 python3-psutil \
    python3-jinja2 python3-icu python3-datrie python3-sqlalchemy \
    python3-asyncpg python3-yaml python3-argparse-manpage \
    # Misc
    git wget lsb-release pandoc potrace clang-tidy \
&& rm -rf /var/lib/apt/lists/*

RUN echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt-get update -qq && apt-get install -y \
    # PostgreSQL
    postgresql-server-dev-14 postgresql-14-postgis-3 \
    postgresql-contrib-14 postgresql-14-postgis-3-scripts \
&& rm -rf /var/lib/apt/lists/*

# Dedicated user account
# ---------------------------------------------------------------------------------------------------------------
ENV USERNAME=nominatim
ENV USERID=1001
ENV USERHOME=/srv/nominatim

RUN groupadd -r --gid ${USERID} ${USERNAME}
RUN useradd --uid ${USERID} --gid ${USERID} -d ${USERHOME} -s /bin/bash -m ${USERNAME}

RUN chmod -R u+rwx ${USERHOME}

USER ${USERNAME}

# Nominatim
# ---------------------------------------------------------------------------------------------------------------
WORKDIR ${USERHOME}

RUN wget https://nominatim.org/release/Nominatim-4.3.2.tar.bz2 \
    && tar xf Nominatim-4.3.2.tar.bz2 \
    && mkdir ${USERHOME}/build \
    && cd ${USERHOME}/build \
    && cmake -DCMAKE_INSTALL_PREFIX=${USERHOME} ${USERHOME}/Nominatim-4.3.2 \
    && make \
    && make install \
    && rm ${USERHOME}/Nominatim-4.3.2.tar.bz2

ENV PATH=${USERHOME}/bin:$PATH

COPY --chown=${USERNAME}:${USERNAME} ./berlin-latest.osm.pbf ${USERHOME}/berlin-latest.osm.pbf


