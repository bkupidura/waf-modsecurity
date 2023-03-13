#!/bin/bash -e

exec 3>&1

WATCH_DIRS="/ssl/ /nginx/"

copy_data() {
    cp -r /nginx/ /etc/
}

/docker-entrypoint.d/10-generate-certificate.sh
/docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.d/90-copy-modsecurity-config.sh
/docker-entrypoint.d/95-activate-rules.sh

mkdir ${WATCH_DIRS} 2> /dev/null || true

{
    copy_data
    nginx -g "daemon off;" && exit 1
} &

NGINX_PID=$!

{
    inotifywait -r -q -e moved_to -m ${WATCH_DIRS} | while read d e f; do
        copy_data

        nginx -t
        if [ $? -eq 0 ]; then
            nginx -s reload
        fi

    done

    kill -9 ${NGINX_PID}
} &

wait -n ${NGINX_PID}
