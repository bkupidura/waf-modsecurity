#!/bin/sh
set -eu

LC_ALL=C
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

cp -a /usr/local/bootstrap/nginx/. "${NGINX_HOME}/"
cp -a /usr/local/bootstrap/modsecurity.d/. /etc/modsecurity.d/

exit 0
