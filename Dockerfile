FROM python:3.11-slim

ENV HOME=/tmp
WORKDIR /app

RUN pip install --no-cache-dir uralicNLP socat

# Download whichever language models you need for the demo, e.g. Komi-Zyrian:
RUN python -m uralicNLP.download --languages kpv koi myv mdf sms sme smn apu lut slh pad

# OpenShift runs containers as an arbitrary non-root UID by default,
# so make sure everything is group-writable/readable.
RUN chgrp -R 0 /app /usr/local/lib/python3.11 && chmod -R g=u /app /usr/local/lib/python3.11

EXPOSE 8080

# Run the MCP server on loopback, and socat-forward 0.0.0.0:8080 -> 127.0.0.1:8000
# so it's reachable from outside the pod. If uralicMCP actually binds 0.0.0.0
# itself, this is harmless — you can drop the socat layer later.
CMD python -m uralicNLP.uralicMCP & \
    sleep 3 && \
    socat TCP-LISTEN:8080,fork,reuseaddr TCP:127.0.0.1:8000
