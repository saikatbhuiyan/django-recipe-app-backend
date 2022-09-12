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
COPY ./app /app
WORKDIR /app
EXPOSE 8000

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# PATH env auto create inside the image on linux os
ENV PATH="/py/bin:$PATH"

USER django-user