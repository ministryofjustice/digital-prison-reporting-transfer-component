CREATE TABLE IF NOT EXISTS admin.multiphase_query_state (
                                              root_execution_id character varying(256) NOT NULL ENCODE lzo COLLATE case_sensitive,
                                              current_execution_id character varying(256) ENCODE lzo COLLATE case_sensitive,
                                              datasource_name character varying(256) ENCODE lzo COLLATE case_sensitive,
                                              catalog character varying(256) ENCODE lzo COLLATE case_sensitive,
                                              database character varying(256) ENCODE lzo COLLATE case_sensitive,
                                              index integer ENCODE az64,
                                              current_state character varying(256) ENCODE lzo COLLATE case_sensitive,
                                              query super COLLATE case_sensitive,
                                              error super COLLATE case_sensitive,
                                              sequence_number integer ENCODE az64,
                                              last_update timestamp without time zone ENCODE az64,
                                              PRIMARY KEY (root_execution_id)
) DISTSTYLE AUTO;