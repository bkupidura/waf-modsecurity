#!/bin/sh
set -eu

/docker-entrypoint.d/0-move-writables.sh
/docker-entrypoint.d/10-generate-certificate.sh
/docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.d/90-copy-modsecurity-config.sh
/docker-entrypoint.d/95-configure-rules.sh

cp -r /nginx/ /etc/
