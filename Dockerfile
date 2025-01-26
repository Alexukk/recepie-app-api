FROM python:3.9-alpine3.13
LABEL maintainer="alexukk"

ENV PYTHONUNBUFFERED 1

# Убедитесь, что requirements.txt и requirements.dev.txt корректно копируются
COPY ./requirements.txt /app/requirements.txt
COPY ./requirements.dev.txt /app/requirements.dev.txt

# Копируем весь проект в контейнер
COPY ./app /app

WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /app/requirements.txt && \
    if [ $DEV = "true" ]; \
    then /py/bin/pip install -r /app/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
    --disabled-password \
    --no-create-home \
    --home /app \
    django-user

ENV PATH="/py/bin:$PATH"

USER django-user
