#!/bin/bash

# Define staging and final destination paths
TMP_DIR="/tmp/pradeeptest-$1"
FINAL_DESTINATION="/var/www/pradeeptest-$1"

# Ensure TMP_DIR exists before running rsync
if [ ! -d "$TMP_DIR" ]; then
  echo "Creating temporary directory: $TMP_DIR"
  mkdir -p "$TMP_DIR"
  chmod 777 "$TMP_DIR"  # Ensure permissions allow rsync to write
fi

# Run rsync command to sync files from staging directory to final destination
rsync -avR --delete --no-relative "$TMP_DIR/" "$FINAL_DESTINATION/"

# Keep www-data:www-data ownership on data/ folder
find "$FINAL_DESTINATION/data/" -type d -exec chown www-data:www-data {} +
