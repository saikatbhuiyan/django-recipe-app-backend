FROM python:3.9-alpine3.13
LABEL mainter="Md. Shahabuddin Bhuiyan"

# Setting PYTHONUNBUFFERED=TRUE or PYTHONUNBUFFERED=1(they are equivalent)
# allows for log messages to be immediately dumped to the stream instead
# of being buffered.
# the stdout and stderr streams are sent straight to terminal (e.g. your container log)
# without being first buffered and that you can see the output of your application
# (e.g. django logs) in real time.

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# every project venv not required
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client jpeg-dev && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev zlib zlib-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# PATH env auto create inside the image on linux os
ENV PATH="/py/bin:$PATH"

USER django-user