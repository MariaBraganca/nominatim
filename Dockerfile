FROM debian:bookworm

EXPOSE 8080

# Required packages
# ---------------------------------------------------------------------------------------------------------------
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -y \
    # For compiling:
    cmake \
    libexpat1-dev \
    libproj-dev \
    lbzip2 \
    libbz2-dev \
    zlib1g-dev \
    libicu-dev \
    nlohmann-json3-dev \
    libboost-dev \
    libboost-system-dev \
    libboost-filesystem-dev \
    postgresql-client-15 \
    g++ \
    liblua5.4-dev \
    libpq-dev \
    python3-dev \
    php \
    # For running:
    python3-dotenv \
    python3-psycopg2 \
    python3-psutil \
    python3-jinja2 \
    python3-sqlalchemy \
    python3-asyncpg \
    python3-icu \
    python3-yaml \
    python3-datrie \
    # For getting the source code:
    wget \
    curl \
&& rm -rf /var/lib/apt/lists/*

# Dedicated user account
# ---------------------------------------------------------------------------------------------------------------
ARG USERNAME=nominatim
ARG USERID=1001
ARG USERHOME=/srv/nominatim

RUN groupadd -r --gid ${USERID} ${USERNAME}
RUN useradd --uid ${USERID} --gid ${USERID} -d ${USERHOME} -s /bin/bash -m ${USERNAME}

RUN chmod -R u+rwx ${USERHOME}

USER ${USERNAME}

# Nominatim
# ---------------------------------------------------------------------------------------------------------------
WORKDIR ${USERHOME}
ARG NOMINATIM_VERSION=4.3.2
ARG INSTALL=${USERHOME}/install

RUN wget https://nominatim.org/release/Nominatim-${NOMINATIM_VERSION}.tar.bz2 \
    && tar xf Nominatim-${NOMINATIM_VERSION}.tar.bz2 \
    && mkdir ${USERHOME}/build \
    && cd ${USERHOME}/build \
    && cmake -DCMAKE_INSTALL_PREFIX=${INSTALL} ${USERHOME}/Nominatim-${NOMINATIM_VERSION} \
    && make \
    && make install \
    && rm ${USERHOME}/Nominatim-${NOMINATIM_VERSION}.tar.bz2

ENV PATH=${INSTALL}/bin:$PATH

# Data
# ---------------------------------------------------------------------------------------------------------------
WORKDIR ${USERHOME}/nominatim-project

COPY --chown=$USERNAME:$USERNAME import.sh ${INSTALL}/bin/import.sh
RUN chmod u+x ${INSTALL}/bin/import.sh

ENTRYPOINT ["import.sh"]
