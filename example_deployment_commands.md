# First time setup
cd /opt/docker/fuseki-deployment
chmod +x fuseki/setup.sh
./fuseki/setup.sh
docker compose up -d

# Future updates (config changes)
git pull
docker compose down
./fuseki/setup.sh  # Re-copies if you deleted the data dir
docker compose up -d

# Or force config update
cp fuseki/config.ttl /opt/docker-data/fuseki/configuration/assembler.ttl
docker compose restart

