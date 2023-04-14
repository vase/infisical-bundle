#!/bin/sh

find /app/frontend/public /app/frontend/.next -type f -name "*.js" |
while read file; do
    sed -i "s|TELEMETRY_CAPTURING_ENABLED|false|g" "$file"
done
