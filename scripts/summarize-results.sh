#!/usr/bin/env bash
set -euo pipefail

RESULTS_DIR="${RESULTS_DIR:-results}"
JOIN_TIMES="${RESULTS_DIR}/join-execution-times-ms.txt"
GRAPH_TIMES="${RESULTS_DIR}/graph-execution-times-ms.txt"

awk -v join_file="${JOIN_TIMES}" -v graph_file="${GRAPH_TIMES}" '
    function summarize(label, file) {
        count = 0
        sum = 0
        min = ""
        max = ""

        while ((getline value < file) > 0) {
            count++
            sum += value
            if (min == "" || value < min) min = value
            if (max == "" || value > max) max = value
        }

        close(file)

        if (count == 0) {
            printf "%s: no samples\n", label
        } else {
            printf "%s: samples=%d avg_ms=%.3f min_ms=%.3f max_ms=%.3f\n", label, count, sum / count, min, max
        }
    }

    BEGIN {
        summarize("JOIN", join_file)
        summarize("GRAPH_TABLE", graph_file)
    }
'
