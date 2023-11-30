FROM python:3.10

# Required packages
# ---------------------------------------------------------------------------------------------------------------
RUN apt update -qq
RUN apt install -y build-essential cmake g++ libboost-dev libboost-system-dev \
                    libboost-filesystem-dev libexpat1-dev zlib1g-dev \
                    libbz2-dev liblua5.3-dev lua5.3 lua-dkjson \
                    nlohmann-json3-dev \
                    php-cli php-pgsql php-intl libicu-dev \
    && rm -rf /var/lib/apt/lists/*

# Dedicated user account
# ---------------------------------------------------------------------------------------------------------------
ENV USERNAME=nominatim
ENV USERHOME=/srv/nominatim

RUN useradd -d ${USERHOME} -s /bin/bash -m ${USERNAME}

RUN chmod a+x ${USERHOME}

# Starlette
# ---------------------------------------------------------------------------------------------------------------
EXPOSE 8000
WORKDIR ${USERHOME}/nominatim-project

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=${USERHOME}/nominatim-project:${PYTHONPATH}

COPY --chown=${USERNAME}:${USERNAME} requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=${USERNAME}:${USERNAME} . .

# Nominatim
# ---------------------------------------------------------------------------------------------------------------
USER ${USERNAME}
WORKDIR ${USERHOME}

RUN wget https://nominatim.org/release/Nominatim-4.3.2.tar.bz2
RUN tar xf Nominatim-4.3.2.tar.bz2

WORKDIR ${USERHOME}/build

RUN cmake -DCMAKE_INSTALL_PREFIX=${USERHOME} ${USERHOME}/Nominatim-4.3.2
RUN make
RUN make install

ENV PATH=${USERHOME}/bin:$PATH

CMD ["uvicorn", "example:app"]