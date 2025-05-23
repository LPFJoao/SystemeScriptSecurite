#!/bin/bash
set -e

sudo apt update
sudo apt install curl -y
sudo apt install jq -y


API_URL="https://api.open-meteo.com/v1/forecast?latitude=43.55&longitude=7.02&current_weather=true"
LOG_FILE="weather_api.log"

echo "=== API CALL at $(date) ===" >> "$LOG_FILE"

RESPONSE=$(curl -w "%{http_code}" -o temp_response.json "$API_URL")
HTTP_CODE="${RESPONSE: -3}"

if [ "$HTTP_CODE" -eq 200 ]; then
    echo "Requête réussie. Température actuelle :" >> "$LOG_FILE"
    jq '.current_weather.temperature' temp_response.json | tee -a "$LOG_FILE"
else
    echo "Erreur HTTP $HTTP_CODE lors de la requête vers l’API." | tee -a "$LOG_FILE"
fi


