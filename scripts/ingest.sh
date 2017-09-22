#!/bin/sh

ERRORS=false

if [ -z "$FEDORA_OBJ_URL" ]; then
    echo "FEDORA_OBJ_URL variable is not set"
    ERRORS=true
fi

if [ -z "$FEDORA_AUTH" ]; then
    echo "FEDORA_AUTH variable is not set"
    ERRORS=true
fi

if [ ! -f "$1" ]; then
    echo "No file given or file doesn't exist: $1"
    ERRORS=true
fi

if [ "$ERRORS" = true ]; then
    echo "There where errors"
    exit 1;
fi

curl -v -u"$FEDORA_AUTH" -H'Content-Type:text/xml' \
    -XPUT -d @$1 "$FEDORA_OBJ_URL?format=info:fedora/fedora-system:FOXML-1.1&ignoreMime=true"

