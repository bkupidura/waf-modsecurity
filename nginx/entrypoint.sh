#!/bin/bash

WATCH_DIRS="/ssl/ /nginx/"

copy_data() {
    cp -r /nginx/ /etc/
}

envsubst < /etc/modsecurity.d/modsecurity-override.conf | sponge /etc/modsecurity.d/modsecurity-override.conf

. /opt/modsecurity/activate-rules.sh

mkdir ${WATCH_DIRS} 2> /dev/null

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
