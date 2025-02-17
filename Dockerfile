FROM owasp/modsecurity-crs:nginx-alpine
MAINTAINER Bartosz Kupidura <bartosz.kupidura@gmail.com>

ENV PARANOIA=1 \
    ANOMALY_INBOUND=5 \
    ANOMALY_OUTBOUND=4 \
    BLOCKING_PARANOIA=1 \
    NGINX_KEEPALIVE_TIMEOUT=60s \
    USER=nginx \
    WORKER_CONNECTIONS=1024 \
    MODSEC_DEFAULT_PHASE1_ACTION="phase:1,pass,log,tag:'\${MODSEC_TAG}'" \
    MODSEC_DEFAULT_PHASE2_ACTION="phase:2,pass,log,tag:'\${MODSEC_TAG}'" \
    MODSEC_RULE_ENGINE=on \
    MODSEC_REQ_BODY_ACCESS=on \
    MODSEC_REQ_BODY_LIMIT=13107200 \
    MODSEC_REQ_BODY_NOFILES_LIMIT=131072 \
    MODSEC_RESP_BODY_ACCESS=on \
    MODSEC_RESP_BODY_LIMIT=1048576 \
    MODSEC_PCRE_MATCH_LIMIT=100000 \
    MODSEC_PCRE_MATCH_LIMIT_RECURSION=100000

USER root

RUN apk add --update inotify-tools bash
RUN wget 'https://github.com/P3TERX/GeoLite.mmdb/releases/latest/download/GeoLite2-Country.mmdb' -O '/etc/modsecurity.d/geolite2-country.mmdb'

COPY nginx/templates/ /etc/nginx/templates/

COPY nginx/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

RUN touch /var/run/nginx.pid

RUN chown -R nginx /var/run/nginx.pid /etc/nginx

USER nginx

ENTRYPOINT ["/entrypoint.sh"]
