#!/bin/sh

. config.sh
. common.sh

duplicity list-current-files --s3-region-name us-east-1 "$DEST"
