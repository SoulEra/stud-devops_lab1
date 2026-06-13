#!/bin/bash
# Координаты
LAT="58.0105"
LON="56.2502"
CITY_NAME="Пермь"
TIMEZONE="Asia%2FYekaterinburg"
INDEX_HTML="/var/www/html/index.html"
CURL_TIMEOUT=10

# Запрос текущих данных: температура, влажность, ветер, время
WEATHER_JSON=$(curl -s --max-time "$CURL_TIMEOUT" \
  "https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m,wind_direction_10m&timezone=${TIMEZONE}&forecast_hours=1")

if [ -z "$WEATHER_JSON" ]; then
    echo "Ошибка получения данных с Open-Meteo" >&2
    echo "<html><body><h1>Ошибка получения погоды</h1><p>Не удалось получить данные. Проверьте интернет-соединение.</p></body></html>" > "$INDEX_HTML"
    exit 0
fi

TEMP=$(echo "$WEATHER_JSON" | jq -r '.hourly.temperature_2m[0] // "нет данных"')
HUMIDITY=$(echo "$WEATHER_JSON" | jq -r '.hourly.relative_humidity_2m[0] // "нет данных"')
WIND_SPEED=$(echo "$WEATHER_JSON" | jq -r '.hourly.wind_speed_10m[0] // "нет данных"')
WIND_DIR=$(echo "$WEATHER_JSON" | jq -r '.hourly.wind_direction_10m[0] // "нет данных"')
OBS_TIME_RAW=$(echo "$WEATHER_JSON" | jq -r '.hourly.time[0] // ""')

# Формат вреvtyb наблюдения в "часы:минуты"
if [ -n "$OBS_TIME_RAW" ]; then
    OBS_TIME=$(echo "$OBS_TIME_RAW" | grep -oP '\d{2}:\d{2}')
    [ -z "$OBS_TIME" ] && OBS_TIME="$OBS_TIME_RAW"
else
    OBS_TIME="нет данных"
fi

GEN_TIME=$(TZ='Asia/Yekaterinburg' date "+%H:%M")
GEN_DATE=$(TZ='Asia/Yekaterinburg' date "+%Y-%m-%d %H:%M:%S")

# Направление ветра в текстовом виде
if [ "$WIND_DIR" != "нет данных" ] && [ -n "$WIND_DIR" ]; then
    WIND_DIR_INT=$(printf "%.0f" "$WIND_DIR" 2>/dev/null || echo "0")
    if [ "$WIND_DIR_INT" -ge 337 ] || [ "$WIND_DIR_INT" -lt 22 ]; then
        WIND_TEXT="С"
    elif [ "$WIND_DIR_INT" -ge 22 ] && [ "$WIND_DIR_INT" -lt 67 ]; then
        WIND_TEXT="СВ"
    elif [ "$WIND_DIR_INT" -ge 67 ] && [ "$WIND_DIR_INT" -lt 112 ]; then
        WIND_TEXT="В"
    elif [ "$WIND_DIR_INT" -ge 112 ] && [ "$WIND_DIR_INT" -lt 157 ]; then
        WIND_TEXT="ЮВ"
    elif [ "$WIND_DIR_INT" -ge 157 ] && [ "$WIND_DIR_INT" -lt 202 ]; then
        WIND_TEXT="Ю"
    elif [ "$WIND_DIR_INT" -ge 202 ] && [ "$WIND_DIR_INT" -lt 247 ]; then
        WIND_TEXT="ЮЗ"
    elif [ "$WIND_DIR_INT" -ge 247 ] && [ "$WIND_DIR_INT" -lt 292 ]; then
        WIND_TEXT="З"
    elif [ "$WIND_DIR_INT" -ge 292 ] && [ "$WIND_DIR_INT" -lt 337 ]; then
        WIND_TEXT="СЗ"
    else
        WIND_TEXT="${WIND_DIR}°"
    fi
else
    WIND_TEXT="нет данных"
fi

cat > "$INDEX_HTML" <<EOF
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="refresh" content="60">
  <title>Погода – $CITY_NAME</title>
  <style>
    body { font-family: sans-serif; margin: 2em; background: #f4f4f4; }
    .data { background: white; padding: 1.5em; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
    .label { font-weight: bold; color: #555; }
    .time { color: #888; font-size: 0.9em; }
  </style>
</head>
<body>
  <h1>Погода в городе $CITY_NAME</h1>
  <div class="data">
    <p><span class="label">🌡️ Температура:</span> ${TEMP} °C</p>
    <p><span class="label">💧 Влажность:</span> ${HUMIDITY}%</p>
    <p><span class="label">🌬️ Ветер:</span> ${WIND_SPEED} м/с, ${WIND_TEXT} (${WIND_DIR}°)</p>
    <p><span class="label">🕒 Время наблюдения:</span> ${OBS_TIME} (UTC+5)</p>
    <hr>
    <p class="time">⏱️ Обновлено: ${GEN_DATE} (UTC+5)</p>
  </div>
</body>
</html>
EOF

echo "Обновлено: HTML=$INDEX_HTML в $GEN_DATE"
