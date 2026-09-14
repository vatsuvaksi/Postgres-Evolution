CREATE PROPERTY GRAPH service_graph
    VERTEX TABLES (
        services
            KEY (id)
            LABEL service
            PROPERTIES (id, name, service_type)
    )
    EDGE TABLES (
        service_dependencies
            SOURCE KEY (service_id)
                REFERENCES services (id)
            DESTINATION KEY (depends_on_id)
                REFERENCES services (id)
            LABEL depends_on
            PROPERTIES (dependency_type)
    );
