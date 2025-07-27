#!/bin/bash

BASE_URL="https://api.openweathermap.org/data/2.5/weather"
API_KEY="50ced219f12abb10adf2e6970efaf72f"

read -p "Enter city name: " CITY

# Fetch weather data
RESPONSE=$(curl -s "${BASE_URL}?q=${CITY}&appid=${API_KEY}&units=metric")


# Check if API request was successful
if echo "$RESPONSE" | jq -e '.cod | tonumber == 200' > /dev/null; then
    TEMP=$(echo "$RESPONSE" | jq '.main.temp')
    WEATHER=$(echo "$RESPONSE" | jq -r '.weather[0].description')
    HUMIDITY=$(echo "$RESPONSE" | jq '.main.humidity')
    WIND_SPEED=$(echo "$RESPONSE" | jq '.wind.speed')

    echo "Weather in $CITY:"
    echo "Temperature: $TEMP°C"
    echo "Condition: $WEATHER"
    echo "Humidity: $HUMIDITY%"
    echo "Wind Speed: $WIND_SPEED m/s"
else
    ERROR_MSG=$(echo "$RESPONSE" | jq -r '.message')
    echo "Error: $ERROR_MSG"
fi
