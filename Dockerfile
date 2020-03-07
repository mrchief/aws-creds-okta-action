FROM python:3.8-slim

RUN apt-get update
RUN apt-get install -y --no-install-recommends oathtool
RUN pip install tokendito

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
