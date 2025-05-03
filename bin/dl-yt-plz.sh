#!/usr/bin/env bash

links=(
  # PUT LINKS HERE (PLAYLIST OR INDIVIDUAL VIDEO ARE BOTH OK)
)

pushd ~/Desktop/Archive/Music
for link in "${links[@]}"; do
  echo "Downloading ${link} ..."
  yt-dlp -k -x --audio-format mp3 "${link}"
done

popd
echo "Done."
