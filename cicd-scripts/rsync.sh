#!/bin/bash

# Define staging and final destination paths
TMP_DIR="/tmp/pradeeptest-$BRANCH_NAME_REPLACE"
FINAL_DESTINATION="/var/www/pradeeptest-$BRANCH_NAME_REPLACE"

# Run rsync command to sync files from staging directory to final destination
rsync -avR --delete --no-relative $TMP_DIR/* "$FINAL_DESTINATION/"

#keep www-data:www-data ownership on data/ folder 
find /var/www/pradeeptest-$BRANCH_NAME_REPLACE/data/ -type d -exec chown www-data:www-data {} + 
