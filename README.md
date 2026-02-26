# xplanet-clouds

I use this repo to keep track of the earth and cloud images that I use to create my desktop wallpaper. Hence, it is quite big. Clone at your own risk.

Create a nifty image using `./scripts/combine-with-clouds.sh --download`.

If you are only interested in the stitched cloud files, then try https://t-animal.github.io/xplanet-clouds/ which should update automatically every six hours from this repo's github actions' artifacts.

## Requirements

Install these tools first:

- `bash`
- `wget`
- `sed`
- `date` (GNU coreutils)
- ImageMagick (`magick` and `montage`)
- `xplanet`

## Quick start

From the repository root:

```bash
./scripts/combine-with-clouds.sh --download
```

This downloads a preprocessed cloud map and renders a final image:

- `earth_terminator_clouds_full.jpg`
- `earth_with_clouds_final.jpg` (cropped final output)

## Run options

### 1) Fast path (recommended)

Use preprocessed cloud data hosted from CI artifacts: `./scripts/combine-with-clouds.sh --download`

Source for these preprocessed cloud files:
https://t-animal.github.io/xplanet-clouds/

### 2) Build cloud input locally from recent data

Download and preprocess clouds (default: 1 hour in the past), then render:

```bash
./scripts/download-and-preprocess.sh
./scripts/combine-with-clouds.sh
```

Use a different offset (for example 3 hours back):

```bash
./scripts/download-and-preprocess.sh 3
./scripts/combine-with-clouds.sh
```

### 3) Manual raw tile download

Download and stitch tiles for a specific UTC date/hour: `./scripts/download-clouds.sh 20260226 12 ./cloud-downloads/clouds_2048_20260226_120000.png`

Then preprocess and render either with `download-and-preprocess.sh` or with `combine-with-clouds.sh --preprocess`.

## How the scripts run

`download-and-preprocess.sh` uses `download-clouds.sh` to download cloud cover. Its output can be used by `combine-with-clouds.sh` to create a final
image of the earth with cloud cover and terminator (day/night).

- `./scripts/download-clouds.sh YYYYMMDD HH [output-file]` downloads raw cloud tiles for the given UTC date/hour and stitches them into one image.
- `./scripts/download-and-preprocess.sh [hour-offset]` picks a recent UTC time (default: 1 hour back), calls `download-clouds.sh`, then levels and scales the result.
- `./scripts/combine-with-clouds.sh [--download] [--preprocess] [--verbose]` renders the final Earth image with `xplanet` and crops it to the wallpaper output.
