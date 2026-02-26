#!/bin/bash

set -eu

HOUR_OFFSET="${1-1}"
SECOND_OFFSET=$((HOUR_OFFSET * 3600))
CURRENT_EPOCH="$(date +%s)"
TARGET_EPOCH="$((CURRENT_EPOCH - SECOND_OFFSET))"

LAST_DATE_UTC="$(date --date="@$TARGET_EPOCH" --utc +%Y%m%d)"
LAST_HOUR_UTC="$(date --date="@$TARGET_EPOCH" --utc +%H)"

cd "$(dirname "$0")/.."

./scripts/download-clouds.sh "$LAST_DATE_UTC" "$LAST_HOUR_UTC" ../earth_clouds.png
magick ./earth_clouds.png -level 14.8,85.6%,0.56 ./earth_clouds_leveled.png
magick ./earth_clouds_leveled.png -scale 5400x2500 ./earth_clouds_leveled_scaled.png
