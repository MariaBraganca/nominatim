FROM ubuntu:22.04

EXPOSE 8080

# Required packages
# ---------------------------------------------------------------------------------------------------------------
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -y \
    build-essential cmake g++ libboost-dev libboost-system-dev \
    libboost-filesystem-dev libexpat1-dev zlib1g-dev \
    libbz2-dev libpq-dev liblua5.3-dev lua5.3 lua-dkjson \
    nlohmann-json3-dev postgresql-14-postgis-3 \
    postgresql-contrib-14 postgresql-14-postgis-3-scripts \
    php-cli php-pgsql php-intl libicu-dev python3-dotenv \
    python3-psycopg2 python3-psutil python3-jinja2 \
    python3-icu python3-datrie python3-sqlalchemy \
    python3-asyncpg python3-yaml \
    wget \
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

RUN wget https://nominatim.org/release/Nominatim-4.3.2.tar.bz2
RUN tar xf Nominatim-4.3.2.tar.bz2

WORKDIR ${USERHOME}/build

RUN cmake -DCMAKE_INSTALL_PREFIX=${USERHOME} ${USERHOME}/Nominatim-4.3.2
RUN make
RUN make install
RUN rm ${USERHOME}/Nominatim-4.3.2.tar.bz2

ENV PATH=${USERHOME}/bin:$PATH

WORKDIR ${USERHOME}/nominatim-project
