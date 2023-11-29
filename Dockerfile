FROM ubuntu:22.04

# Required software
# ---------------------------------------------------------------------------------------------------------------
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -qq
RUN apt install -y build-essential cmake g++ libboost-dev libboost-system-dev \
                    libboost-filesystem-dev libexpat1-dev zlib1g-dev \
                    libbz2-dev libpq-dev liblua5.3-dev lua5.3 lua-dkjson \
                    nlohmann-json3-dev postgresql-14-postgis-3 \
                    postgresql-contrib-14 postgresql-14-postgis-3-scripts \
                    php-cli php-pgsql php-intl libicu-dev python3-dotenv \
                    python3-psycopg2 python3-psutil python3-jinja2 \
                    python3-icu python3-datrie python3-sqlalchemy \
                    python3-asyncpg python3-yaml \
                    wget

# Dedicated user account
# ---------------------------------------------------------------------------------------------------------------
ENV USERNAME=nominatim
ENV USERHOME=/srv/nominatim

RUN useradd -d ${USERHOME} -s /bin/bash -m ${USERNAME}

USER ${USERNAME}

RUN chmod a+x ${USERHOME}

# Nominatim
# ---------------------------------------------------------------------------------------------------------------
WORKDIR ${USERHOME}

RUN wget https://nominatim.org/release/Nominatim-4.3.2.tar.bz2
RUN tar xf Nominatim-4.3.2.tar.bz2

WORKDIR ${USERHOME}/build

RUN cmake -DCMAKE_INSTALL_PREFIX=${USERHOME} ${USERHOME}/Nominatim-4.3.2
RUN make
RUN make install

ENV PATH=${USERHOME}/bin:$PATH

# Project
# ---------------------------------------------------------------------------------------------------------------
WORKDIR ${USERHOME}/nominatim-project
