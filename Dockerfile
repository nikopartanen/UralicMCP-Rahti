FROM python:3.11-slim

ENV HOME=/tmp
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends socat \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir "mcp<2" uralicNLP

RUN python -m uralicNLP.download --languages kpv koi myv mdf sms sme smn apu lut slh pad

RUN chgrp -R 0 /app /usr/local/lib/python3.11 && chmod -R g=u /app /usr/local/lib/python3.11

EXPOSE 8080

CMD python -m uralicNLP.uralicMCP & \
    sleep 3 && \
    socat TCP-LISTEN:8080,fork,reuseaddr TCP:127.0.0.1:8000
