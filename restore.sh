#!/bin/sh

# Enable debugging (optional)
# set -x

# Source the configuration and common functions
. config.sh
. common.sh

# Load AWS credentials
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY

# Determine encryption option
if [ -n "$GPG_KEY" ]; then
    ENCRYPT_OPTION="--encrypt-key $GPG_KEY"
else
    ENCRYPT_OPTION="--no-encryption"
fi

# Check if a specific path is provided for restoration
if [ -n "$1" ]; then
    SPECIFIC_PATH="$1"
    echo "Restoring specific path: $SPECIFIC_PATH"
    # Adjust the restore directory if needed
    # RESTORE_DIR="/path/to/restore/location/for/specific/file"
else
    echo "Restoring all files"
fi

# Create the restore directory if it doesn't exist
mkdir -p "$RESTORE_DIR"

# Run the restore command
if [ -n "$SPECIFIC_PATH" ]; then
    # Restore a specific file or directory using --path-to-restore
    duplicity restore \
        --s3-region-name us-east-1 \
        --s3-use-ia \
        $ENCRYPT_OPTION \
        --gpg-options "$GPG_OPTIONS" \
        --progress \
        --tempdir "$TEMP_DIR" \
        --path-to-restore "$SPECIFIC_PATH" \
        "$DEST" "$RESTORE_DIR"
else
    # Restore all files
    duplicity restore \
        --s3-region-name us-east-1 \
        --s3-use-ia \
        $ENCRYPT_OPTION \
        --gpg-options "$GPG_OPTIONS" \
        --progress \
        --tempdir "$TEMP_DIR" \
        "$DEST" "$RESTORE_DIR"
fi

# Check if the restore was successful
if [ $? -eq 0 ]; then
    echo "Restore completed successfully on $(date)"
else
    echo "Restore failed on $(date)"
fi
