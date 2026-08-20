#!/bin/bash
set -e

DATASET_NAME="${1:-main}"
GRAPH_IRI="${2:-http://biblocal/bnlbibliography}"
NT_FILE="${3:-bnbl_bibliographic.nt}"

DB_PATH="./data/databases/${DATASET_NAME}"

echo "Loading ${NT_FILE} into ${GRAPH_IRI} (${DATASET_NAME})..."

# Stop Fuseki if running
docker compose stop fuseki 2>/dev/null || true

# Remove old database if exists (for clean reload)
if [ -d "$DB_PATH" ]; then
    echo "Removing existing database at ${DB_PATH}..."
    rm -rf "$DB_PATH"
fi

mkdir -p "$DB_PATH"

# Load with secoresearch/fuseki image (includes tdb2.tdbloader)
docker run --rm \
    -v "$(pwd)/data/databases":/fuseki-base/databases \
    -v "$(pwd)/data:/data:ro" \
    secoresearch/fuseki:5.4.0 \
    bash -c "tdb2.tdbloader --loc /fuseki-base/databases/${DATASET_NAME} --graph ${GRAPH_IRI} --loader=parallel /data/${NT_FILE}"

echo "Load complete. Restarting Fuseki..."
docker compose start fuseki

echo "Dataset ${DATASET_NAME} available at http://localhost:3030/${DATASET_NAME}/sparql"
