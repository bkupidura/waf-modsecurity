FROM owasp/modsecurity-crs:3.3.2-nginx-alpine
MAINTAINER Bartosz Kupidura <bartosz.kupidura@gmail.com>

ENV PARANOIA=1 \
    ANOMALY_INBOUND=5 \
    ANOMALY_OUTBOUND=4 \
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

RUN apk add --update inotify-tools bash

RUN rm -fr /etc/nginx/templates/conf.d /etc/nginx/templates/includes /etc/nginx/templates/nginx.conf.template

COPY nginx/conf/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d/* /etc/nginx/conf.d/

COPY nginx/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
