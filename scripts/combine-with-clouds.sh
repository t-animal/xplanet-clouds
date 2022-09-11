#!/bin/bash

cd $(dirname $0)

#curl http://xplanetclouds.com/free/local/clouds_2048.jpg -z clouds_2048.jpg -o clouds_2048.jpg --silent --location
#curl https://www.ssec.wisc.edu/data/comp/latest_moll.gif -z clouds_640.gif -o clouds_640.gif --silent --location
curl https://data.ventusky.com/2022/08/30/icon/whole_world/hour_10/icon_oblacnost_20220830_10.jpg -z clouds_720.jpg -o clouds_720.jpg --silent --location


#only for ventusky:
convert clouds_720.jpg -resize 5400x2700 -blur 10x30 -auto-level clouds_5400.jpg

sed -s s/MONTH/01/ config.ventusky.template > config
xplanet -config config -body earth -geometry 5400x2700 -output earth_terminator_full.jpg -num_times 1 -projection rectangular  2>&1 | grep -v Resizing | grep -v performance
convert -crop 5400x2500+0+100 earth_terminator_full.jpg earth_terminator.jpg
