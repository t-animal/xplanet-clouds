#!/bin/bash

set -eu

VERBOSE=0
DO_PREPROCESS=0
DO_DOWNLOAD=0

log() {
  if [[ "$VERBOSE" -eq 1 ]]; then
    echo "[combine-with-clouds] $*"
  fi
}

usage() {
  echo "usage: $0 [--preprocess] [--download] [--verbose]"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --preprocess)
      DO_PREPROCESS=1
      ;;
    --download)
      DO_DOWNLOAD=1
      ;;
    --verbose)
      VERBOSE=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

cd "$(dirname "$0")/.."

if [[ "$DO_PREPROCESS" -eq 1 ]]; then
  log "Preprocessing latest cloud download"
  latest_cloud_file="$(ls -1 -- cloud-downloads/ | tail -n 1)"
  log "Using input cloud file: cloud-downloads/$latest_cloud_file"
  magick "cloud-downloads/$latest_cloud_file" -scale 5400x2500 -level 14.8,85.6%,0.56 earth_clouds_scaled_leveled.png
  log "Wrote earth_clouds_scaled_leveled.png"
fi

if [[ "$DO_DOWNLOAD" -eq 1 ]]; then
  log "Downloading preprocessed cloud map"
  wget --quiet -N https://t-animal.github.io/xplanet-clouds/earth_clouds_leveled_scaled.png
  log "Download step complete"
fi

log "Generating config from scripts/config.template"
sed -s "s/MONTH/$(date +%m)/" scripts/config.template > config
log "Rendering xplanet output"

if [[ "$VERBOSE" -eq 1 ]]; then
  xplanet -config config -body earth -geometry 5400x2700 -output earth_terminator_clouds_full.jpg -num_times 1 -projection rectangular
else
  xplanet -config config -body earth -geometry 5400x2700 -output earth_terminator_clouds_full.jpg -num_times 1 -projection rectangular  2>&1 | grep -v Resizing | grep -v performance
fi

log "Cropping final output"
magick earth_terminator_clouds_full.jpg -crop 5400x2500+0+100 earth_with_clouds_final.jpg
log "Done: earth_with_clouds_final.jpg"
