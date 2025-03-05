#!/bin/bash

# Define staging and final destination paths
TMP_DIR="/tmp/pradeeptest-$BRANCH_NAME_REPLACE"
FINAL_DESTINATION="/var/www/pradeeptest-$BRANCH_NAME_REPLACE"

# Ensure TMP_DIR exists before running rsync
if [ ! -d "$TMP_DIR" ]; then
  echo "Creating temporary directory: $TMP_DIR"
  mkdir -p "$TMP_DIR"
  chmod 777 "$TMP_DIR"  # Ensure permissions allow rsync to write
fi

# Run rsync command to sync files from staging directory to final destination
rsync -avR --delete --no-relative "$TMP_DIR/" "$FINAL_DESTINATION/"

# Keep www-data:www-data ownership on data/ folder 
find "/var/www/pradeeptest-$BRANCH_NAME_REPLACE/data/" -type d -exec chown www-data:www-data {} +
