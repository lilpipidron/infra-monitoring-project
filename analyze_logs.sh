#!/usr/bin/env bash

N="${1:-300}"
LOG="access.log"

IPS=(192.168.1.10 192.168.1.25 10.0.0.5 10.0.0.7 172.16.0.3 8.8.8.8)
REQS=("GET /api/users" "POST /api/login" "GET /api/orders" "DELETE /api/orders/67")
CODES=(200 200 200 201 301 401 403 404 500 503)

for ((i = 0; i < N; i++)); do
    printf '%s - - [15/Aug/2026:10:%02d:%02d] "%s HTTP/1.1" %s\n' \
        "${IPS[RANDOM % ${#IPS[@]}]}" $((i / 60 % 60)) $((i % 60)) \
        "${REQS[RANDOM % ${#REQS[@]}]}" "${CODES[RANDOM % ${#CODES[@]}]}"
done > "$LOG"

IP_RE='^([0-9]{1,3}\.){3}[0-9]{1,3}'

echo "Всего запросов: $(grep -cE "$IP_RE" "$LOG")"

echo "Топ-3 IP:"
grep -oE "$IP_RE" "$LOG" | sort | uniq -c | sort -rn | head -3 \
    | awk '{ print "  " $2 " — " $1 }'

awk '$NF ~ /^4/ { c4++ } $NF ~ /^5/ { c5++ }
     END { print "4xx: " c4+0 "\n5xx: " c5+0 }' "$LOG"
