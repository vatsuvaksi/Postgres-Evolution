# PostgreSQL 19 Property Graph Benchmark

This project builds a local PostgreSQL 19 benchmark for comparing a traditional SQL join traversal with the SQL/PGQ `GRAPH_TABLE` syntax over the same service dependency graph.

## Project Layout

- `docker-compose.yml` starts PostgreSQL 19 and loads the SQL files in `sql/`.
- `sql/01_schema.sql` creates the relational tables and indexes.
- `sql/02_seed.sql` inserts 50,000 services and about 250,000 dependency edges.
- `sql/03_graph.sql` creates the `service_graph` property graph.
- `queries/` contains standalone SQL files for normal queries, explain plans, and count benchmarks.
- `scripts/` contains convenience wrappers for checks and repeated benchmark runs.
- `results/` is where benchmark output files are written.

## Requirements

- Docker
- Docker Compose
- A PostgreSQL 19 image that supports SQL/PGQ property graphs

## Start PostgreSQL

```bash
docker compose up -d
```

The Compose file defaults to `postgres:19`, matching the requested setup. You can override the image if your PostgreSQL 19 build is published under a different tag:

```bash
POSTGRES_IMAGE=your-compatible-postgres-image docker compose up -d
```

PostgreSQL initializes the first time the named Docker volume is created. If you change files under `sql/` after the database has already initialized, reset the volume:

```bash
docker compose down -v
docker compose up -d
```

## Check The Database

```bash
scripts/check-database.sh
```

This checks the container, PostgreSQL version, registered property graph, service count, and dependency edge count.

Expected data shape:

- `services`: 50,000 rows
- `service_dependencies`: about 250,000 rows
- `service_graph`: one property graph exposed through `information_schema.property_graphs`

## Run The Queries

Traditional three-hop join:

```bash
scripts/run-query.sh queries/join-three-hops.sql
```

Property graph three-hop traversal:

```bash
scripts/run-query.sh queries/graph-three-hops.sql
```

Both queries look for services exactly three dependency hops upstream of `service-100`.

## Compare Execution Plans

Join plan:

```bash
scripts/run-query.sh queries/explain-join-three-hops.sql
```

Graph plan:

```bash
scripts/run-query.sh queries/explain-graph-three-hops.sql
```

Look at the reported `Execution Time`, buffer usage, and whether PostgreSQL chooses similar join/index paths for both formulations.

## Run Repeated Benchmarks

The count benchmark mirrors the original recipe and writes one count per run.

```bash
scripts/benchmark-join.sh
scripts/benchmark-graph.sh
```

Results:

- `results/join-results.txt`
- `results/graph-results.txt`

For actual execution-time samples, run:

```bash
scripts/benchmark-timed.sh
scripts/summarize-results.sh
```

Timing results:

- `results/join-execution-times-ms.txt`
- `results/graph-execution-times-ms.txt`

The summary prints sample count, average milliseconds, minimum milliseconds, and maximum milliseconds for both approaches.

See `RESULTS.md` for the validation outcome from this workspace.

## Result Notes

The benchmark is designed to compare two equivalent ways of expressing the same traversal:

- The join query is explicit relational SQL with three repeated joins through `service_dependencies`.
- The graph query expresses the same path using `GRAPH_TABLE`, `MATCH`, vertex labels, and edge labels.

The original count loops prove both formulations return a stable result across repeated runs. The timed benchmark is the better comparison for performance because it extracts PostgreSQL's measured `Execution Time` from `EXPLAIN ANALYZE`.

## Useful Commands

Open a shell in the database container:

```bash
docker exec -it pg19-graph-benchmark psql -U postgres -d graphdemo
```

Stop the database but keep data:

```bash
docker compose down
```

Stop the database and remove seeded data:

```bash
docker compose down -v
```
