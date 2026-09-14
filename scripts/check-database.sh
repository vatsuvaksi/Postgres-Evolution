#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="${CONTAINER_NAME:-pg19-graph-benchmark}"
DATABASE_USER="${DATABASE_USER:-postgres}"
DATABASE_NAME="${DATABASE_NAME:-graphdemo}"

docker compose ps

docker exec "${CONTAINER_NAME}" \
    psql -U "${DATABASE_USER}" -d "${DATABASE_NAME}" \
    -c "SELECT version();"

docker exec "${CONTAINER_NAME}" \
    psql -U "${DATABASE_USER}" -d "${DATABASE_NAME}" \
    -c "SELECT property_graph_name FROM information_schema.property_graphs;"

docker exec "${CONTAINER_NAME}" \
    psql -U "${DATABASE_USER}" -d "${DATABASE_NAME}" \
    -c "SELECT count(*) AS services FROM services;"

docker exec "${CONTAINER_NAME}" \
    psql -U "${DATABASE_USER}" -d "${DATABASE_NAME}" \
    -c "SELECT count(*) AS dependency_edges FROM service_dependencies;"
