# Benchmark Results

Run date: 2026-09-14 14:26:09 IST

## System Configuration

| Item | Value |
| --- | --- |
| Host OS | macOS 26.6.2, build 25G83 |
| Architecture | arm64 |
| Processor | Apple M4 |
| CPU cores reported by macOS | 10 physical, 10 logical |
| Host memory | 24 GiB |
| Docker Engine | 28.3.2 |
| Docker Compose | 2.38.2-desktop.1 |
| Container image | postgres:19beta3 |
| Container status | running, healthy |
| Docker memory visible in `docker stats` | 7.654 GiB |

## Database Configuration

| Item | Value |
| --- | --- |
| Container | pg19-graph-benchmark |
| Database | graphdemo |
| PostgreSQL version | PostgreSQL 19beta3 (Debian 19~beta3-1.pgdg13+1), 64-bit |
| PostgreSQL architecture | aarch64-unknown-linux-gnu |
| Property graph | service_graph |
| Service rows | 50,000 |
| Dependency edge rows | 250,000 |

## Benchmark Workload

Both query styles traverse three upstream dependency hops from `service-100`.

The traditional SQL query uses explicit joins through `service_dependencies`.

The property graph query uses `GRAPH_TABLE`, `MATCH`, the `service` vertex label, and the `depends_on` edge label.

## Repeated Count Results

The original repeated benchmark scripts ran 20 iterations each.

| Query | Samples | Unique returned count value |
| --- | ---: | ---: |
| JOIN count benchmark | 20 | 13 |
| `GRAPH_TABLE` count benchmark | 20 | 125 |

Important note: these two original count queries are not perfectly equivalent. The JOIN count query counts `DISTINCT s3.id`, while the graph count query counts all path rows emitted by `GRAPH_TABLE`. In this graph, there are 125 three-hop paths but only 13 distinct impacted services.

## Timed Results

Timing was captured from `EXPLAIN (ANALYZE, BUFFERS, TIMING OFF)` over 20 samples per query.

| Query | Samples | Average ms | Minimum ms | Maximum ms |
| --- | ---: | ---: | ---: | ---: |
| JOIN | 20 | 0.188 | 0.167 | 0.262 |
| `GRAPH_TABLE` | 20 | 0.158 | 0.149 | 0.195 |

## Raw Timing Samples

JOIN execution times in milliseconds:

```text
0.262
0.198
0.204
0.183
0.175
0.181
0.179
0.180
0.176
0.178
0.167
0.173
0.173
0.227
0.183
0.171
0.211
0.172
0.186
0.180
```

`GRAPH_TABLE` execution times in milliseconds:

```text
0.156
0.161
0.195
0.161
0.157
0.149
0.153
0.161
0.158
0.152
0.159
0.157
0.157
0.156
0.152
0.158
0.157
0.158
0.153
0.157
```

## Interpretation

On this run, both query forms are very fast for the selected three-hop traversal. The `GRAPH_TABLE` query had a slightly lower average execution time than the explicit JOIN query, but the absolute difference is small at this scale and should not be treated as a broad performance conclusion.

The more meaningful result is that PostgreSQL 19beta3 successfully created the SQL/PGQ property graph and executed `GRAPH_TABLE` traversal syntax against the seeded service dependency dataset.

For apples-to-apples count comparisons, the graph query should also apply `DISTINCT` when comparing against the existing JOIN benchmark.
