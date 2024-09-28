#!/bin/sh

# Source the configuration and common functions
. config.sh
. common.sh

# Build include and exclude options
INCLUDES=$(build_includes)
EXCLUDES=$(build_excludes)

# Remove backups older than 6 months
duplicity remove-older-than 6M "$DEST" --force

# Print variables for debugging
echo "BASE_DIR: $BASE_DIR"
echo "INCLUDES: $INCLUDES"
echo "EXCLUDES: $EXCLUDES"
echo "DEST: $DEST"

# Determine encryption option
if [ -n "$GPG_KEY" ]; then
    ENCRYPT_OPTION="--encrypt-key $GPG_KEY"
else
    ENCRYPT_OPTION="--no-encryption"
fi

# Run the backup with specified options
duplicity backup --s3-region-name us-east-1 $VERBOSE \
    --s3-use-ia \
    $ENCRYPT_OPTION \
    --gpg-options "$GPG_OPTIONS" \
    --progress \
    --tempdir "$TEMP_DIR" \
    --full-if-older-than 6M \
    $INCLUDES $EXCLUDES \
    "$BASE_DIR" "$DEST"

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Backup completed successfully on $(date)"

    # Verify the last backup
    echo "Verifying the last backup..."
    duplicity verify \
        --s3-region-name us-east-1 \
        --s3-use-ia \
        $ENCRYPT_OPTION \
        --gpg-options "$GPG_OPTIONS" \
        --tempdir "$TEMP_DIR" \
        "$DEST" "$BASE_DIR"

    if [ $? -eq 0 ]; then
        echo "Backup verification completed successfully on $(date)"
    else
        echo "Backup verification failed on $(date)"
    fi
else
    echo "Backup failed on $(date)"
fi
