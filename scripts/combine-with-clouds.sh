#!/bin/bash

set -eu

ARG="${1-}"

cd "$(dirname "$0")/.."

if [[ "$ARG" == "--preprocess" ]]; then
  latest_cloud_file="$(ls -1 -- cloud-downloads/ | tail -n 1)"
  magick "cloud-downloads/$latest_cloud_file" -scale 5400x2500 -level 14.8,85.6%,0.56 earth_clouds_scaled_leveled.png
fi

if [[ "$ARG" == "--download" ]]; then
  wget --quiet -N https://t-animal.github.io/xplanet-clouds/earth_clouds_leveled_scaled.png
fi

sed -s "s/MONTH/$(date +%m)/" scripts/config.template > config
xplanet -config config -body earth -geometry 5400x2700 -output earth_terminator_clouds_full.jpg -num_times 1 -projection rectangular  2>&1 | grep -v Resizing | grep -v performance

magick earth_terminator_clouds_full.jpg -crop 5400x2500+0+100 earth_with_clouds_final.jpg
