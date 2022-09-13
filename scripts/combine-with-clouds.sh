#!/bin/bash

cd $(dirname $0)/..

if [[ "$1" == "--preprocess" ]]; then
  convert cloud-downloads/$(ls -1 cloud-downloads/ | tail -n1) -scale 5400x2500 -level 14.8,85.6%,0.56 earth_clouds_scaled_leveled.png
fi

if [[ "$1" == "--download" ]]; then
  wget --quiet -N https://t-animal.github.io/xplanet-clouds/earth_clouds_leveled_scaled.png
fi

sed -s s/MONTH/$(date +%m)/ scripts/config.template > config
xplanet -config config -body earth -geometry 5400x2700 -output earth_terminator_clouds_full.jpg -num_times 1 -projection rectangular  2>&1 | grep -v Resizing | grep -v performance

convert -crop 5400x2500+0+100 earth_terminator_clouds_full.jpg earth_with_clouds_final.jpg
