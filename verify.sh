#!/bin/sh

# Source the configuration and common functions
. config.sh
. common.sh

# Load AWS credentials
load_aws_credentials

# Ensure TEMP_DIR exists
mkdir -p "$TEMP_DIR"
chmod 700 "$TEMP_DIR"

# Verify the last backup
echo "Verifying the last backup on $(date)..." | tee -a "$LOGFILE"

duplicity verify \
    --s3-region-name us-east-1 \
    --s3-use-ia \
    $ENCRYPT_OPTION \
    --gpg-options "$GPG_OPTIONS" \
    --progress \
    --tempdir "$TEMP_DIR" \
    "$DEST" "$BASE_DIR" 2>&1 | tee -a "$LOGFILE"

# Check if the verification was successful
if [ $? -eq 0 ]; then
    echo "Backup verification completed successfully on $(date)" | tee -a "$LOGFILE"
else
    echo "Backup verification failed on $(date)" | tee -a "$LOGFILE"
fi
