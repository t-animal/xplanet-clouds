#!/bin/bash

set -eu

cd "$(dirname "$0")/../"

ZOOM=2
COLS=3
ROWS=3

if [[ $# -lt 2 ]]; then
  echo "usage: $0 <date as YYYYMMDD> hour [output-file]"
  echo "To download newest use: $0 \$(date +%Y%m%d) \$(date +%H)"
  exit 1
fi

DATE="$1"
TIME="$2"0000
OUTPUT="${3-}"

if [[ -z "$OUTPUT" ]]; then
  OUTPUT="../cloud-downloads/clouds_2048_${DATE}_${TIME}.png"
fi

BASE="https://re.ssec.wisc.edu/api/image?products=globalir_${DATE}_${TIME}&equirectangular=true"

mkdir -p patches
rm -f patches/*

DOWNLOADED=0
TOTAL=$(((COLS*2+2)*(ROWS+1)))

for ((COL = 0; COL <= COLS * 2 + 1; COL++)); do
  for ((ROW = 0; ROW <= ROWS; ROW++)); do
    wget --quiet "$BASE&z=$ZOOM&x=$COL&y=$ROW" -O "patches/zoom-$ZOOM--row-$ROW--col-$COL.png"
    echo -ne "\rDownloaded $DOWNLOADED of $TOTAL"
    DOWNLOADED=$((DOWNLOADED + 1))
  done
done


echo -e "\rDownloads done. Stitching..."
cd patches
montage -mode concatenate -tile 8x4 zoom* "$OUTPUT"