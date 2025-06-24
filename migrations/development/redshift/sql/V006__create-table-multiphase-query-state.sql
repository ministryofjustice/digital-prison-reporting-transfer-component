CREATE TABLE IF NOT EXISTS admin.multiphase_query_state (
                                              root_execution_id character varying(256) NOT NULL ENCODE lzo,
                                              current_execution_id character varying(256) ENCODE lzo,
                                              datasource_name character varying(256) ENCODE lzo,
                                              catalog character varying(256) ENCODE lzo,
                                              database character varying(256) ENCODE lzo,
                                              index integer ENCODE az64,
                                              current_state character varying(256) ENCODE lzo,
                                              query super,
                                              error super,
                                              sequence_number integer ENCODE az64,
                                              last_update timestamp without time zone ENCODE az64,
                                              PRIMARY KEY (root_execution_id)
) DISTSTYLE AUTO;