#!/usr/bin/env bash
set -euo pipefail

ITERATIONS="${ITERATIONS:-20}"
CONTAINER_NAME="${CONTAINER_NAME:-pg19-graph-benchmark}"
DATABASE_USER="${DATABASE_USER:-postgres}"
DATABASE_NAME="${DATABASE_NAME:-graphdemo}"
RESULTS_DIR="${RESULTS_DIR:-results}"
OUTPUT_FILE="${RESULTS_DIR}/join-results.txt"

mkdir -p "${RESULTS_DIR}"
: > "${OUTPUT_FILE}"

for i in $(seq 1 "${ITERATIONS}"); do
    docker exec -i "${CONTAINER_NAME}" \
        psql -U "${DATABASE_USER}" -d "${DATABASE_NAME}" -At \
        < queries/count-join-three-hops.sql >> "${OUTPUT_FILE}"
done

echo "Wrote ${ITERATIONS} JOIN benchmark rows to ${OUTPUT_FILE}"
