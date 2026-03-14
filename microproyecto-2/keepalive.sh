#!/bin/bash

if [ "$#" -lt 3 ]; then
    echo "Uso: $0 IP1 IP2 IP3 [TIEMPO_SEGUNDOS]"
    exit 1
fi

IP1="$1"
IP2="$2"
IP3="$3"
TIEMPO="${4:-15}"

while true; do
    curl -X GET "http://$IP1"
    curl -X GET "http://$IP2"
    curl -X POST -F img=@horse.jpg "http://$IP3/predict"
    sleep "$TIEMPO"
done
