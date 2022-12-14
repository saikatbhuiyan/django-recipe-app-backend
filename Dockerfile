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
COPY ./scripts /scripts
WORKDIR /app
EXPOSE 8000

# every project venv not required
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client jpeg-dev && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev zlib zlib-dev linux-headers && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user && \
    mkdir -p /vol/web/media && \
    mkdir -p /vol/web/static && \
    chown -R django-user:django-user /vol && \
    chmod -R 755 /vol && \
    chmod -R +x /scripts
    # here -p is for create all sub dir if not exists
    # django-user:django-user  [user group]
    # make sure /scripts is executable

# PATH env auto create inside the image on linux os

# ENV PATH="/py/bin:$PATH"
ENV PATH="/scripts:/py/bin:$PATH"

USER django-user

CMD ["run.sh"]
# default cmd for run server or application
