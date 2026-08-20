#!/bin/bash
set -e

FUSEKI_DATA="/opt/docker-data/fuseki"

echo "Setting up Fuseki persistent data..."

# Create directories
sudo mkdir -p "$FUSEKI_DATA/configuration"
sudo mkdir -p "$FUSEKI_DATA/databases"

# Copy config (idempotent)
if [ ! -f "$FUSEKI_DATA/configuration/assembler.ttl" ]; then
    echo "Copying config.ttl..."
    sudo cp fuseki/config.ttl "$FUSEKI_DATA/configuration/assembler.ttl"
else
    echo "Config already exists, skipping..."
fi

# Fix permissions
sudo chown -R 1000:1000 "$FUSEKI_DATA"

echo "✓ Setup complete"
echo "Run: docker compose up -d"
