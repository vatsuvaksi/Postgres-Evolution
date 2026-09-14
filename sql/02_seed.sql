INSERT INTO services (name, service_type)
SELECT
    'service-' || g,
    CASE
        WHEN g % 5 = 0 THEN 'database'
        WHEN g % 5 = 1 THEN 'api'
        WHEN g % 5 = 2 THEN 'worker'
        WHEN g % 5 = 3 THEN 'queue'
        ELSE 'cache'
    END
FROM generate_series(1, 50000) AS g;

INSERT INTO service_dependencies (
    service_id,
    depends_on_id,
    dependency_type
)
SELECT
    s,
    ((s + offset_value) % 50000) + 1,
    CASE
        WHEN offset_value % 3 = 0 THEN 'http'
        WHEN offset_value % 3 = 1 THEN 'async'
        ELSE 'storage'
    END
FROM generate_series(1, 50000) AS s
CROSS JOIN generate_series(1, 5) AS offset_value
WHERE ((s + offset_value) % 50000) + 1 <> s
ON CONFLICT DO NOTHING;

ANALYZE services;
ANALYZE service_dependencies;
