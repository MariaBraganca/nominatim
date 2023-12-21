FROM python:3.10

EXPOSE 8000

# Dedicated user account
# ---------------------------------------------------------------------------------------------------------------
ENV USERNAME=nominatim
ENV USERID=1001
ENV USERHOME=/srv/nominatim

RUN groupadd -r --gid ${USERID} ${USERNAME}
RUN useradd --uid ${USERID} --gid ${USERID} -d ${USERHOME} -s /bin/bash -m ${USERNAME}

RUN chmod -R u+rwx ${USERHOME}

USER ${USERNAME}

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

CMD ["gunicorn", "-b", "0.0.0.0:8000", "-w", "4", "-k","uvicorn.workers.UvicornWorker", "example:app"]