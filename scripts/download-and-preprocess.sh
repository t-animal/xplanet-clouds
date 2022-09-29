#!/bin/bash

set -e

HOUR_OFFSET="$1"
if [[ "$1" == "" ]]; then
	HOUR_OFFSET=1
fi
SECOND_OFFSET=$(("$HOUR_OFFSET" * 3600))

LAST_DATE_UTC=$(date --date=@$(($(date +%s)-$SECOND_OFFSET)) --utc +%Y%m%d)
LAST_HOUR_UTC=$(date --date=@$(($(date +%s)-$SECOND_OFFSET)) --utc +%H)

cd "$(dirname $0)"/..

./scripts/download-clouds.sh "$LAST_DATE_UTC" "$LAST_HOUR_UTC" ../earth_clouds.png
convert ./earth_clouds.png -level 14.8,85.6%,0.56 ./earth_clouds_leveled.png
convert ./earth_clouds_leveled.png -scale 5400x2500 ./earth_clouds_leveled_scaled.png
