FROM quay.io/jupyter/scipy-notebook:python-3.11

LABEL org.opencontainers.image.title="Curso Ciencia de Datos Biomedicina"
LABEL org.opencontainers.image.authors="Antonio Daniel Martinez Gutierrez"

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
        postgresql-client \
        graphviz \
        curl \
        git \
    && rm -rf /var/lib/apt/lists/*
USER ${NB_UID}

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt && \
    fix-permissions "${CONDA_DIR}" && fix-permissions "/home/${NB_USER}"

WORKDIR /home/jovyan/work
