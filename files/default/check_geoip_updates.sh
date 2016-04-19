#!/bin/bash
set -e
cd $WORKING_DIR

notify_callbacks=0

rm -rf tmp_download
mkdir tmp_download

geoipupdate -d "$WORKING_DIR/tmp_download" -f "$WORKING_DIR/geoipupdate.conf"

for new_file in tmp_download/*; do
  new_hash=$(shasum $new_file | awk '{print $1}')

  current_file="${new_file##tmp_download/}"
  if [ -e $current_file ]; then
    current_hash=$(shasum $current_file | awk '{print $1}')
  else
    current_hash=""
  fi

  if [ "$new_hash" != "$current_hash" ]; then
    echo "updating $current_file"
    cp -f $new_file $current_file
    notify_callbacks=1
  fi
done

if [ $notify_callbacks -eq 1 ]; then
  for callback in callback.d/*; do
    source $callback
  done
fi

rm -rf tmp_download
