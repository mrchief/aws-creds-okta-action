FROM jfloff/alpine-python:3.8-slim
#RUN apk add libffi-dev openssl-dev libxml2-dev libxslt-dev
RUN /entrypoint.sh \
  -p mintotp \
  -p tokendito\
  -b libxml2-dev \
  -b libxslt-dev \
  -b libffi-dev \
  -b openssl-dev \
  #-a libxml2 \
  -a libxslt

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
