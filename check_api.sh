#!/usr/bin/env bash

URL="$1"

if [[ ! "$URL" =~ ^https?://[A-Za-z0-9.-]+(:[0-9]+)?(/.*)?$ ]]; then
    echo "Некорректный URL: $URL" >&2
    exit 1
fi

CODE=$(curl -s -o /dev/null -w '%{http_code}' \
    --max-time 10 --retry 3 --retry-delay 2 "$URL")

if [[ "$CODE" == "200" ]]; then
    echo "API доступен"
    exit 0
else
    echo "API недоступен, код ответа: $CODE"
    exit 1
fi
