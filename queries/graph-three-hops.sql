SELECT impacted_service
FROM GRAPH_TABLE (
    service_graph
    MATCH
        (root IS service WHERE root.name = 'service-100')
        <-[IS depends_on]-(s1 IS service)
        <-[IS depends_on]-(s2 IS service)
        <-[IS depends_on]-(s3 IS service)
    COLUMNS (
        s3.name AS impacted_service
    )
);
