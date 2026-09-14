CREATE TABLE services (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    service_type TEXT NOT NULL
);

CREATE TABLE service_dependencies (
    service_id BIGINT NOT NULL REFERENCES services(id),
    depends_on_id BIGINT NOT NULL REFERENCES services(id),
    dependency_type TEXT NOT NULL,
    PRIMARY KEY (service_id, depends_on_id)
);

CREATE INDEX idx_service_dependencies_service
    ON service_dependencies(service_id);

CREATE INDEX idx_service_dependencies_dependency
    ON service_dependencies(depends_on_id);
