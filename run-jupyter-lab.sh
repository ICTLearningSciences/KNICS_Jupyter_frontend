#!/bin/bash

PORT=5644

# Get the absolute path to the `knic-jupyter` directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SOURCE="$DIR/src/index.ts"
CONFIG="$DIR/config.py"

PRODUCTION_ENDPOINT="https://knic.isi.edu/engine"
DEVELOPMENT_ENDPOINT="http://localhost:5642/knic"

# Rebuild Jupyter Lab library to work with `knic-engine` running on localhost
if [ "$1" = "--develop" ] ; then
    echo "Running Jupyter Lab in DEVELOPMENT mode.."
    sed -i -e "s|$PRODUCTION_ENDPOINT|$DEVELOPMENT_ENDPOINT|gw changelog.txt" "$SOURCE"
    if [ -s changelog.txt ]; then
        cat changelog.txt
    fi
    echo "knic-engine endpoint = $DEVELOPMENT_ENDPOINT"
else
    echo "Running Jupyter Lab in PRODUCTION mode.."
    sed -i -e "s|$DEVELOPMENT_ENDPOINT|$PRODUCTION_ENDPOINT|gw changelog.txt" "$SOURCE"
    if [ -s changelog.txt ]; then
        cat changelog.txt
    fi
    echo "knic-engine endpoint = $PRODUCTION_ENDPOINT"
fi

if [ -s changelog.txt ]; then
    pip install -ve .
fi

jupyter lab --no-browser --allow-root --port $PORT --config=$CONFIG
