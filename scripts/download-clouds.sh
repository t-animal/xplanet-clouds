#!/bin/bash

set -e

cd $(dirname $0)/../

ZOOM=2
COLS=3
ROWS=3

DATE=20220908
TIME=150000

BASE="https://re.ssec.wisc.edu/api/image?products=globalir_${DATE}_${TIME}&equirectangular=true"

mkdir -p patches
rm -f patches/*

for COL in $(seq 0 "$(calc $COLS*2+1)" ); do 
  for ROW in $(seq 0 "$(calc $ROWS)" ); do
    wget "$BASE&z=$ZOOM&x=$COL&y=$ROW" -O "patches/zoom-$ZOOM--row-$ROW--col-$COL.png"
  done
done

cd patches
montage -mode concatenate -tile 8x4 zoom* ../clouds/clouds_2048_$DATE_$TIME.png