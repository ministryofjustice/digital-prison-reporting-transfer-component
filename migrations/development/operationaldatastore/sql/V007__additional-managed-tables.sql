-- Nomis

CREATE TABLE prisons.nomis_areas
(
    area_class                    text,
    area_code                     text,
    description                   text,
    parent_area_code              text,
    list_seq                      integer,
    active_flag                   text,
    expiry_date                   timestamp,
    area_type                     text,
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

CREATE TABLE prisons.nomis_agency_locations
(
    agy_loc_id                    text,
    description                   text,
    agency_location_type          text,
    district_code                 text,
    updated_allowed_flag          text,
    abbreviation                  text,
    deactivation_date             timestamp,
    contact_name                  text,
    print_queue                   text,
    jurisdiction_code             text,
    bail_office_flag              text,
    list_seq                      integer,
    housing_lev_1_code            text,
    housing_lev_2_code            text,
    housing_lev_3_code            text,
    housing_lev_4_code            text,
    property_lev_1_code           text,
    property_lev_2_code           text,
    property_lev_3_code           text,
    last_booking_no               numeric(10, 0),
    commissary_privilege          text,
    business_hours                text,
    address_type                  text,
    service_required_flag         text,
    active_flag                   text,
    disability_access_code        text,
    intake_flag                   text,
    sub_area_code                 text,
    area_code                     text,
    noms_region_code              text,
    geographic_region_code        text,
    justice_area_code             text,
    cjit_code                     text,
    long_description              text,
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
    audit_additional_info         text,
    payroll_region                text
);

CREATE TABLE prisons.nomis_agency_internal_locations
(
    internal_location_id          numeric(10, 0),
    internal_location_code        text,
    agy_loc_id                    text,
    internal_location_type        text,
    description                   text,
    security_level_code           text,
    capacity                      integer,
    create_user_id                text,
    parent_internal_location_id   numeric(10, 0),
    active_flag                   text,
    list_seq                      integer,
    create_datetime               timestamp,
    modify_datetime               timestamp,
    modify_user_id                text,
    cna_no                        numeric(10, 0),
    certified_flag                text,
    deactivate_date               timestamp,
    reactivate_date               timestamp,
    deactivate_reason_code        text,
    comment_text                  text,
    user_desc                     text,
    aca_cap_rating                integer,
    unit_type                     text,
    operation_capacity            integer,
    no_of_occupant                numeric(10, 0),
    tracking_flag                 text,
    audit_timestamp               timestamp,
    audit_user_id                 text,
    audit_module_name             text,
    audit_client_user_id          text,
    audit_client_ip_address       text,
    audit_client_workstation_name text,
    audit_additional_info         text
);

CREATE TABLE prisons.nomis_staff_members
(
    staff_id                      numeric(10, 0),
    assigned_caseload_id          text,
    working_stock_loc_id          text,
    working_caseload_id           text,
    user_id                       text,
    badge_id                      text,
    last_name                     text,
    first_name                    text,
    middle_name                   text,
    abbreviation                  text,
    position                      text,
    birthdate                     timestamp,
    termination_date              timestamp,
    update_allowed_flag           text,
    default_printer_id            numeric(10, 0),
    suspended_flag                text,
    supervisor_staff_id           numeric(10, 0),
    comm_receipt_printer_id       text,
    personnel_type                text,
    as_of_date                    timestamp,
    emergency_contact             text,
    role                          text,
    sex_code                      text,
    status                        text,
    suspension_date               timestamp,
    suspension_reason             text,
    force_password_change_flag    text,
    last_password_change_date     timestamp,
    license_code                  text,
    license_expiry_date           timestamp,
    create_datetime               timestamp,
    create_user_id                text,
    modify_datetime               timestamp,
    modify_user_id                text,
    title                         text,
    name_sequence                 text,
    queue_cluster_id              integer,
    audit_timestamp               timestamp,
    audit_user_id                 text,
    audit_module_name             text,
    audit_client_user_id          text,
    audit_client_ip_address       text,
    audit_client_workstation_name text,
    audit_additional_info         text,
    first_logon_flag              text,
    significant_date              timestamp,
    significant_name              text,
    national_insurance_number     text
);

CREATE TABLE prisons.nomis_staff_user_accounts
(
    username                      text,
    staff_id                      numeric(10, 0),
    staff_user_type               text,
    id_source                     text,
    working_caseload_id           text,
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
    audit_additional_info         text,
    stakeholder_id                numeric(10, 0),
    stakeholder_expiry_date       timestamp,
    last_logon_date               timestamp
);

-- DPS Locations Inside Prison

CREATE TABLE prisons.locationsinsideprison_location
(
    id                              uuid,
    prison_id                       text,
    path_hierarchy                  text,
    code                            text,
    location_type                   text,
    parent_id                       uuid,
    local_name                      text,
    comments                        text,
    order_within_parent_location    integer,
    residential_housing_type        text,
    certification_id                bigint,
    capacity_id                     bigint,
    deactivated_date                timestamp,
    deactivated_reason              text,
    proposed_reactivation_date      date,
    when_created                    timestamp,
    when_updated                    timestamp,
    updated_by                      text,
    accommodation_type              text,
    planet_fm_reference             text,
    converted_cell_type             text,
    other_converted_cell_type       text,
    archived_reason                 text,
    deactivated_by                  text,
    deactivation_reason_description text,
    location_type_discriminator     text,
    status                          text,
    locked                          boolean,
    pending_change_id               bigint,
    in_cell_sanitation              boolean,
    cell_mark                       text,
    residential_structure           text
);

-- DPS Prison Register

CREATE TABLE prisons.prisonregister_prison_type
(
    id        integer,
    prison_id text,
    type      text
);

CREATE TABLE prisons.prisonregister_prison_category
(
    category  text,
    prison_id text
);

CREATE TABLE prisons.prisonregister_prison_operator
(
    prison_id   text,
    operator_id text
);

CREATE TABLE prisons.prisonregister_operator
(
    id   integer,
    name text
);

CREATE TABLE prisons.prisonregister_prison
(
    prison_id            text,
    name                 text,
    active               boolean,
    description          text,
    male                 boolean,
    female               boolean,
    inactive_date        date,
    contracted           boolean,
    lthse                boolean,
    gp_practice_code     text,
    prison_name_in_welsh text
);

-- Configure these tables to be loaded to the Operational Data Store during data loads/CDC

INSERT INTO configuration.datahub_managed_tables (source, table_name)
VALUES ('nomis', 'areas'),
       ('nomis', 'agency_locations'),
       ('nomis', 'agency_internal_locations'),
       ('nomis', 'staff_members'),
       ('nomis', 'staff_user_accounts'),
       ('locationsinsideprison', 'location'),
       ('prisonregister', 'prison_type'),
       ('prisonregister', 'prison_category'),
       ('prisonregister', 'prison_operator'),
       ('prisonregister', 'operator'),
       ('prisonregister', 'prison');
