FROM nginxinc/nginx-unprivileged:1-alpine
LABEL maintainer="Md. Shahabuddin Bhuiyan"

COPY ./default.conf.tpl /etc/nginx/default.conf.tpl
COPY ./uwsgi_params /etc/nginx/uwsgi_params
COPY ./run.sh /run.sh

ENV LISTEN_PORT=8000
ENV APP_HOST=app
ENV APP_PORT=9000

USER root
# use root user for run this command
RUN mkdir -p /vol/static && \
    chmod 755 /vol/static && \
    touch /etc/nginx/conf.d/default.conf && \
    chown nginx:nginx /etc/nginx/conf.d/default.conf && \
    chmod +x /run.sh

# make sure /run.sh is executable

VOLUME /vol/static

# switch to nginx user
USER nginx

CMD ["/run.sh"]