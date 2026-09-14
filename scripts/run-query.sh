#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 path/to/query.sql" >&2
    exit 1
fi

QUERY_FILE="$1"
CONTAINER_NAME="${CONTAINER_NAME:-pg19-graph-benchmark}"
DATABASE_USER="${DATABASE_USER:-postgres}"
DATABASE_NAME="${DATABASE_NAME:-graphdemo}"

docker exec -i "${CONTAINER_NAME}" \
    psql -U "${DATABASE_USER}" -d "${DATABASE_NAME}" \
    < "${QUERY_FILE}"
