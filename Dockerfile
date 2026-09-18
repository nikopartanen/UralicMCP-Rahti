FROM python:3.11-slim

ENV HOME=/tmp
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends nginx \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir "mcp<2" uralicNLP
RUN python -m uralicNLP.download --languages kpv
RUN python -c "from uralicNLP import uralicApi; uralicApi.get_translation('кӧч', 'kpv')"

COPY index.html /app/static/index.html
COPY nginx.conf /etc/nginx/nginx.conf

RUN chgrp -R 0 /app /usr/local/lib/python3.11 /etc/nginx /var/lib/nginx /var/log/nginx \
    && chmod -R g=u /app /usr/local/lib/python3.11 /etc/nginx /var/lib/nginx /var/log/nginx \
    && mkdir -p /var/lib/nginx/body /run \
    && chgrp -R 0 /var/lib/nginx /run && chmod -R g=u /var/lib/nginx /run

EXPOSE 8080

CMD python -m uralicNLP.uralicMCP & \
    sleep 3 && \
    nginx -g "daemon off;"
