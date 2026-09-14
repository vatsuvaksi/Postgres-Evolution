SELECT count(*)
FROM (
    SELECT DISTINCT s3.id
    FROM services root
    JOIN service_dependencies d1
        ON d1.depends_on_id = root.id
    JOIN services s1
        ON s1.id = d1.service_id
    JOIN service_dependencies d2
        ON d2.depends_on_id = s1.id
    JOIN services s2
        ON s2.id = d2.service_id
    JOIN service_dependencies d3
        ON d3.depends_on_id = s2.id
    JOIN services s3
        ON s3.id = d3.service_id
    WHERE root.name = 'service-100'
) q;
