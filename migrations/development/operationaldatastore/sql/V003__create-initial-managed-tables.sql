CREATE TABLE nomis.offenders
(
    offender_id                   numeric(10, 0),
    offender_name_seq             numeric(38, 0),
    id_source_code                text,
    last_name                     text,
    name_type                     text,
    first_name                    text,
    middle_name                   text,
    birth_date                    timestamp,
    sex_code                      text,
    suffix                        text,
    last_name_soundex             text,
    birth_place                   text,
    birth_country_code            text,
    create_date                   timestamp,
    last_name_key                 text,
    alias_offender_id             numeric(10, 0),
    first_name_key                text,
    middle_name_key               text,
    offender_id_display           text,
    root_offender_id              numeric(10, 0),
    caseload_type                 text,
    modify_user_id                text,
    modify_datetime               timestamp,
    alias_name_type               text,
    parent_offender_id            numeric(10, 0),
    unique_obligation_flag        text,
    suspended_flag                text,
    suspended_date                timestamp,
    race_code                     text,
    remark_code                   text,
    add_info_code                 text,
    birth_county                  text,
    birth_state                   text,
    middle_name_2                 text,
    title                         text,
    age                           integer,
    create_user_id                text,
    last_name_alpha_key           text,
    create_datetime               timestamp,
    name_sequence                 text,
    audit_timestamp               timestamp,
    audit_user_id                 text,
    audit_module_name             text,
    audit_client_user_id          text,
    audit_client_ip_address       text,
    audit_client_workstation_name text,
    audit_additional_info         text
);

CREATE TABLE nomis.offender_bookings
(
    offender_book_id              numeric(10, 0),
    booking_begin_date            timestamp,
    booking_end_date              timestamp,
    booking_no                    text,
    offender_id                   numeric(10, 0),
    agy_loc_id                    text,
    living_unit_id                numeric(10, 0),
    disclosure_flag               text,
    in_out_status                 text,
    active_flag                   text,
    booking_status                text,
    youth_adult_code              text,
    finger_printed_staff_id       numeric(10, 0),
    search_staff_id               numeric(10, 0),
    photo_taking_staff_id         numeric(10, 0),
    assigned_staff_id             numeric(10, 0),
    create_agy_loc_id             text,
    booking_type                  text,
    booking_created_date          timestamp,
    root_offender_id              numeric(10, 0),
    agency_iml_id                 numeric(10, 0),
    service_fee_flag              text,
    earned_credit_level           text,
    ekstrand_credit_level         text,
    intake_agy_loc_id             text,
    activity_date                 timestamp,
    intake_caseload_id            text,
    intake_user_id                text,
    case_officer_id               integer,
    case_date                     timestamp,
    case_time                     timestamp,
    community_active_flag         text,
    create_intake_agy_loc_id      text,
    comm_staff_id                 numeric(10, 0),
    comm_status                   text,
    community_agy_loc_id          text,
    no_comm_agy_loc_id            integer,
    comm_staff_role               text,
    agy_loc_id_list               text,
    status_reason                 text,
    total_unexcused_absences      integer,
    request_name                  text,
    create_datetime               timestamp,
    create_user_id                text,
    modify_datetime               timestamp,
    modify_user_id                text,
    record_user_id                text,
    intake_agy_loc_assign_date    timestamp,
    audit_timestamp               timestamp,
    audit_user_id                 text,
    audit_module_name             text,
    audit_client_user_id          text,
    audit_client_ip_address       text,
    audit_client_workstation_name text,
    audit_additional_info         text,
    booking_seq                   integer,
    admission_reason              text
);

CREATE TABLE nomis.offender_profile_details
(
    offender_book_id              numeric(10, 0),
    profile_seq                   integer,
    profile_type                  text,
    profile_code                  text,
    list_seq                      integer,
    comment_text                  text,
    caseload_type                 text,
    modify_user_id                text,
    modify_datetime               timestamp,
    create_datetime               timestamp,
    create_user_id                text,
    audit_timestamp               timestamp,
    audit_user_id                 text,
    audit_module_name             text,
    audit_client_user_id          text,
    audit_client_ip_address       text,
    audit_client_workstation_name text,
    audit_additional_info         text
);

CREATE TABLE nomis.profile_codes
(
    profile_type                  text,
    profile_code                  text,
    description                   text,
    list_seq                      integer,
    update_allowed_flag           text,
    active_flag                   text,
    expiry_date                   timestamp,
    user_id                       text,
    modified_date                 timestamp,
    create_datetime               timestamp,
    create_user_id                text,
    modify_datetime               timestamp,
    modify_user_id                text,
    audit_timestamp               timestamp,
    audit_user_id                 text,
    audit_module_name             text,
    audit_client_user_id          text,
    audit_client_ip_address       text,
    audit_client_workstation_name text,
    audit_additional_info         text
);

CREATE TABLE nomis.offender_identifiers
(
    offender_id                   numeric(10, 0),
    offender_id_seq               numeric(10, 0),
    identifier_type               text,
    identifier                    text,
    issued_authority_text         text,
    issued_date                   timestamp,
    root_offender_id              numeric(10, 0),
    caseload_type                 text,
    modify_user_id                text,
    modify_datetime               timestamp,
    verified_flag                 text,
    create_datetime               timestamp,
    create_user_id                text,
    audit_timestamp               timestamp,
    audit_user_id                 text,
    audit_module_name             text,
    audit_client_user_id          text,
    audit_client_ip_address       text,
    audit_client_workstation_name text,
    audit_additional_info         text
);

CREATE TABLE nomis.offender_languages
(
    offender_book_id              numeric(10, 0),
    language_type                 text,
    language_code                 text,
    read_skill                    text,
    speak_skill                   text,
    write_skill                   text,
    comment_text                  text,
    modify_datetime               timestamp,
    modify_user_id                text,
    create_datetime               timestamp,
    create_user_id                text,
    numeracy_skill                text,
    prefered_write_flag           text,
    prefered_speak_flag           text,
    interpreter_requested_flag    text,
    audit_timestamp               timestamp,
    audit_user_id                 text,
    audit_module_name             text,
    audit_client_user_id          text,
    audit_client_ip_address       text,
    audit_client_workstation_name text,
    audit_additional_info         text
);

CREATE TABLE nomis.offender_sentence_terms
(
    offender_book_id              numeric(10, 0),
    sentence_seq                  integer,
    term_seq                      integer,
    sentence_term_code            text,
    years                         integer,
    months                        integer,
    weeks                         integer,
    days                          integer,
    start_date                    timestamp,
    end_date                      timestamp,
    life_sentence_flag            text,
    modify_datetime               timestamp,
    modify_user_id                text,
    create_datetime               timestamp,
    create_user_id                text,
    hours                         integer,
    audit_timestamp               timestamp,
    audit_user_id                 text,
    audit_module_name             text,
    audit_client_user_id          text,
    audit_client_ip_address       text,
    audit_client_workstation_name text,
    audit_additional_info         text
);

CREATE TABLE nomis.reference_codes
(
    domain                        text,
    code                          text,
    description                   text,
    list_seq                      integer,
    active_flag                   text,
    system_data_flag              text,
    modify_user_id                text,
    expired_date                  timestamp,
    new_code                      text,
    parent_code                   text,
    parent_domain                 text,
    create_datetime               timestamp,
    create_user_id                text,
    modify_datetime               timestamp,
    audit_timestamp               timestamp,
    audit_user_id                 text,
    audit_module_name             text,
    audit_client_user_id          text,
    audit_client_ip_address       text,
    audit_client_workstation_name text,
    audit_additional_info         text
);

CREATE TABLE nomis.offender_assessments
(
    offender_book_id              numeric(10, 0),
    assessment_seq                integer,
    assessment_date               timestamp,
    assessment_type_id            numeric(10, 0),
    score                         numeric(8, 2),
    assess_status                 text,
    calc_sup_level_type           text,
    assess_staff_id               numeric(10, 0),
    assess_comment_text           text,
    override_reason_text          text,
    place_agy_loc_id              text,
    overrided_sup_level_type      text,
    override_comment_text         text,
    override_staff_id             numeric(10, 0),
    evaluation_date               timestamp,
    next_review_date              timestamp,
    evaluation_result_code        text,
    review_sup_level_type         text,
    review_placement_text         text,
    review_committe_code          text,
    committe_comment_text         text,
    review_place_agy_loc_id       text,
    review_sup_level_text         text,
    modify_user_id                text,
    assess_committe_code          text,
    creation_date                 timestamp,
    creation_user                 text,
    approved_sup_level_type       text,
    assessment_create_location    text,
    assessor_staff_id             numeric(10, 0),
    modify_datetime               timestamp,
    override_user_id              text,
    override_reason               text,
    create_datetime               timestamp,
    create_user_id                text,
    audit_timestamp               timestamp,
    audit_user_id                 text,
    audit_module_name             text,
    audit_client_user_id          text,
    audit_client_ip_address       text,
    audit_client_workstation_name text,
    audit_additional_info         text
);
