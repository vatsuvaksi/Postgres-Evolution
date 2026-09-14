#!/usr/bin/env bash
set -euo pipefail

ITERATIONS="${ITERATIONS:-20}"
RESULTS_DIR="${RESULTS_DIR:-results}"
JOIN_TIMES="${RESULTS_DIR}/join-execution-times-ms.txt"
GRAPH_TIMES="${RESULTS_DIR}/graph-execution-times-ms.txt"

mkdir -p "${RESULTS_DIR}"
: > "${JOIN_TIMES}"
: > "${GRAPH_TIMES}"

for i in $(seq 1 "${ITERATIONS}"); do
    scripts/run-query.sh queries/explain-join-three-hops.sql \
        | awk '/Execution Time/ {print $3}' >> "${JOIN_TIMES}"
done

for i in $(seq 1 "${ITERATIONS}"); do
    scripts/run-query.sh queries/explain-graph-three-hops.sql \
        | awk '/Execution Time/ {print $3}' >> "${GRAPH_TIMES}"
done

echo "Wrote JOIN timings to ${JOIN_TIMES}"
echo "Wrote graph timings to ${GRAPH_TIMES}"
