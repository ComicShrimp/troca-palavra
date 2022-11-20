FROM python:3.10

LABEL maintainer="Mário Victor Ribeiro Silva <mariovictorrs@gmail.com>"
LABEL description="Container para Troca Palavra API"

# Atualiza imagem
ENV TZ America/Sao_Paulo
RUN apt-get clean -y
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get autoremove -y

# Poetry
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=off
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100
ENV POETRY_HOME="/opt/poetry"
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_NO_INTERACTION=1
ENV PYTHON_SETUP_PATH="/opt/python_setup"
ENV VENV_PATH="/opt/python_setup/.venv"
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"
ENV PYTHONPATH="/app"

ENV POETRY_VERSION=1.2.1

RUN apt-get install --no-install-recommends -y build-essential curl
RUN curl -sSL https://install.python-poetry.org | python
RUN poetry --version
RUN poetry config virtualenvs.create false
WORKDIR $PYTHON_SETUP_PATH
COPY ./poetry.lock ./pyproject.toml ./
RUN poetry install --no-root

WORKDIR  /app

COPY ./ ./

WORKDIR /app

RUN cat ./scripts/start-reload.sh > /start-reload.sh

CMD ["bash", "/start-reload.sh"]