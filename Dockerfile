FROM python:3.10

EXPOSE 8000

# Required packages
# ---------------------------------------------------------------------------------------------------------------
RUN apt-get update -qq && apt-get install -y \
    build-essential cmake g++ libboost-dev libboost-system-dev \
    libboost-filesystem-dev libexpat1-dev zlib1g-dev \
    libbz2-dev liblua5.3-dev lua5.3 lua-dkjson \
    nlohmann-json3-dev \
    php-cli php-pgsql php-intl libicu-dev \
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

# Starlette
# ---------------------------------------------------------------------------------------------------------------
WORKDIR ${USERHOME}/nominatim-project

COPY --chown=${USERNAME}:${USERNAME} requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY --chown=${USERNAME}:${USERNAME} . .

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=${USERHOME}/nominatim-project:${PYTHONPATH}
ENV PATH=${USERHOME}/.local/bin:$PATH

CMD ["uvicorn", "example:app", "--host", "0.0.0.0", "--port", "8000"]
