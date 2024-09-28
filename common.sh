#!/bin/sh

# Function to load AWS credentials
load_aws_credentials() {
    export AWS_ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY
}

# Function to build include options
build_includes() {
    local includes=""
    for path in $INCLUDE_PATHS; do
        includes="$includes --include $path"
    done
    echo "$includes"
}

# Function to build exclude options
build_excludes() {
    local excludes=""
    for path in $EXCLUDE_PATHS; do
        excludes="$excludes --exclude $path"
    done
    echo "$excludes"
}
