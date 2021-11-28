#!/bin/sh

# Start by loading certs
/reload-certs.sh

# Schedule reloads of certs
crond &

exit 0

