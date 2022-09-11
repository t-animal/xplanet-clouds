#!/bin/bash

cd $(dirname $0)

convert ../cloud-downloads/$(ls -1 ../cloud-downloads/ | tail -n1) -level 14.8,85.6%,0.56 ../earth_clouds_leveled.png

sed -s s/MONTH/$(date +%m)/ config.template > config
xplanet -config config -body earth -geometry 5400x2700 -output ../earth_terminator_clouds_full.jpg -num_times 1 -projection rectangular  2>&1 | grep -v Resizing | grep -v performance

convert -crop 5400x2500+0+100 ../earth_terminator_clouds_full.jpg ../earth_with_clouds_final.jpg
