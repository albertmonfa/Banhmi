FROM python:3.7.1-alpine3.8

ENV APP_ROOT /banhmi
WORKDIR /

EXPOSE 8080/tcp

COPY docker/banhmi/conf/requirements.txt /tmp/
COPY docker/banhmi/scripts/docker-entrypoint.sh /bin/docker-entrypoint
COPY src ${APP_ROOT}

RUN apk update && apk --no-cache add bash && \
    mkdir /etc/banhmi && \
    pip install -r /tmp/requirements.txt && \
    chmod +x /bin/docker-entrypoint && \
    chmod +x /banhmi/banhmi && \
    ln -s /usr/local/bin/python /usr/bin/python && \
    ln -s /banhmi/banhmi /usr/bin/banhmi && \
    rm -rf /tmp/requirements.txt

ENTRYPOINT ["/bin/docker-entrypoint"]
CMD ["banhmi"]
