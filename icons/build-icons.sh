#!/bin/sh
# Rebuilds every icon PNG from drone.svg. Needs macOS and ImageMagick (`brew install imagemagick`).
set -e
cd "$(dirname "$0")"

DRONE=$(sed '1d' drone.svg)
DEFS='<defs>
  <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" stop-color="#3550c8"/>
    <stop offset="1" stop-color="#141c52"/>
  </linearGradient>
  <radialGradient id="glow" cx="0.32" cy="0.25" r="0.75">
    <stop offset="0" stop-color="#ffffff" stop-opacity="0.18"/>
    <stop offset="1" stop-color="#ffffff" stop-opacity="0"/>
  </radialGradient>
</defs>'

# Standard icon: rounded square, drone nearly full size.
cat > icon.svg <<EOF
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 512 512">
$DEFS
<rect width="512" height="512" rx="112" fill="url(#bg)"/>
<rect width="512" height="512" rx="112" fill="url(#glow)"/>
<g transform="translate(256 256) scale(0.92) translate(-256 -256)">$DRONE</g>
</svg>
EOF

# Full-bleed square: Android masks it and iOS rounds the corners itself.
# The drone is shrunk to sit inside the 80% safe zone.
cat > icon-square.svg <<EOF
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 512 512">
$DEFS
<rect width="512" height="512" fill="url(#bg)"/>
<rect width="512" height="512" fill="url(#glow)"/>
<g transform="translate(256 256) scale(0.8) translate(-256 -256)">$DRONE</g>
</svg>
EOF

# ImageMagick's built-in SVG renderer mangles gradients and <use>, so let macOS
# Quick Look (WebKit) rasterise at 1024px, then downscale with ImageMagick.
TMP=$(mktemp -d)
qlmanage -t -s 1024 -o "$TMP" icon.svg icon-square.svg >/dev/null 2>&1
magick "$TMP/icon.svg.png" -resize 512x512 icon-512.png
magick "$TMP/icon.svg.png" -resize 192x192 icon-192.png
magick "$TMP/icon-square.svg.png" -resize 512x512 icon-maskable-512.png
magick "$TMP/icon-square.svg.png" -resize 180x180 -background "#141c52" -flatten apple-touch-icon.png
rm -rf "$TMP"
rm icon-square.svg
echo "Icons rebuilt."
