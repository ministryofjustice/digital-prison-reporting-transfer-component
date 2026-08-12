CREATE TABLE IF NOT EXISTS
admin.statement_execution_status (
    id bigint NOT NULL identity(1, 1) ENCODE az64,
    status character varying(30) NOT NULL ENCODE lzo COLLATE case_sensitive,
    table_id character varying(100) NOT NULL ENCODE lzo COLLATE case_sensitive,
    execution_id character varying(100) NOT NULL ENCODE lzo COLLATE case_sensitive,
    error_message character varying(1000) ENCODE lzo COLLATE case_sensitive,
    created_at timestamp without time zone NOT NULL DEFAULT ('now':: text):: timestamp without time zone ENCODE az64,
    updated_at timestamp without time zone ENCODE az64,
    PRIMARY KEY (id)
) DISTSTYLE AUTO;
