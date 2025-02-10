CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE; -- https://stackoverflow.com/a/49111932/3192769

CREATE USER openfmb_user WITH PASSWORD 'password';

CREATE SCHEMA openfmb;

DROP TABLE IF EXISTS openfmb.deviceName;

CREATE TABLE openfmb.deviceName
(
  device_uuid uuid not null,
  name TEXT not null
);

INSERT INTO openfmb.deviceName (device_uuid, name)
VALUES
  ('0706D5D7-6BB0-41D1-AECF-ED3D8363E4B9', 'siemens48'),
  ('F992EDDA-E80D-45C8-B9D5-7323106D42F4', 'siemens40'),
  ('6EDCC07F-63F5-4771-B3A2-7B10A20896B9', 'abb48'),
  ('3F776F78-6382-44C1-9B09-F6822FDBEB1B', 'wallbox48'),
  ('22921BFD-5495-4E46-BAB7-2BFD99EDE938', 'grizzle40')
;

DROP TABLE IF EXISTS openfmb.raw_data;

CREATE TABLE openfmb.raw_data
(
    message_uuid uuid not null,
    "timestamp" timestamp with time zone default now() not null,
    device_uuid uuid not null,
    tagname varchar(100) not null,
    value jsonb not null
);

-- Timescale setup hyertable and continuous aggregates
-- Reference: https://docs.timescale.com/tutorials/latest/energy-data/dataset-energy/

DROP TABLE IF EXISTS openfmb.data;

CREATE TABLE openfmb.data
(
    message_uuid uuid not null,
    "timestamp" timestamp with time zone default now() not null,
    device_uuid uuid not null,
    tagname varchar(100) not null,
    a_net_mag numeric,
    a_neut_mag numeric,
    a_phsa_mag numeric,
    a_phsb_mag numeric,
    a_phsc_mag numeric,
    hz_mag numeric,
    pf_neut_mag numeric,
    pf_net_mag numeric,
    pf_phsa_mag numeric,
    pf_phsb_mag numeric,
    pf_phsc_mag numeric,
    phv_neut_mag numeric,
    phv_neut_ang numeric,
    phv_net_mag numeric,
    phv_net_ang numeric,
    phv_phsa_mag numeric,
    phv_phsa_ang numeric,
    phv_phsb_mag numeric,
    phv_phsb_ang numeric,
    phv_phsc_mag numeric,
    phv_phsc_ang numeric,
    ppv_phsab_mag numeric,
    ppv_phsab_ang numeric,
    ppv_phsbc_mag numeric,
    ppv_phsbc_ang numeric,
    ppv_phsca_mag numeric,
    ppv_phsca_ang numeric,
    va_neut_mag numeric,
    va_net_mag numeric,
    va_phsa_mag numeric,
    va_phsb_mag numeric,
    va_phsc_mag numeric,
    var_neut_mag numeric,
    var_net_mag numeric,
    var_phsa_mag numeric,
    var_phsb_mag numeric,
    var_phsc_mag numeric,
    w_neut_mag numeric,
    w_net_mag numeric,
    w_phsa_mag numeric,
    w_phsb_mag numeric,
    w_phsc_mag numeric,
    -- start load side
    a_net_mag_1 numeric,
    a_neut_mag_1 numeric,
    a_phsa_mag_1 numeric,
    a_phsb_mag_1 numeric,
    a_phsc_mag_1 numeric,
    hz_mag_1 numeric,
    pf_neut_mag_1 numeric,
    pf_net_mag_1 numeric,
    pf_phsa_mag_1 numeric,
    pf_phsb_mag_1 numeric,
    pf_phsc_mag_1 numeric,
    phv_neut_mag_1 numeric,
    phv_neut_ang_1 numeric,
    phv_net_mag_1 numeric,
    phv_net_ang_1 numeric,
    phv_phsa_mag_1 numeric,
    phv_phsa_ang_1 numeric,
    phv_phsb_mag_1 numeric,
    phv_phsb_ang_1 numeric,
    phv_phsc_mag_1 numeric,
    phv_phsc_ang_1 numeric,
    ppv_phsab_mag_1 numeric,
    ppv_phsab_ang_1 numeric,
    ppv_phsbc_mag_1 numeric,
    ppv_phsbc_ang_1 numeric,
    ppv_phsca_mag_1 numeric,
    ppv_phsca_ang_1 numeric,
    va_neut_mag_1 numeric,
    va_net_mag_1 numeric,
    va_phsa_mag_1 numeric,
    va_phsb_mag_1 numeric,
    va_phsc_mag_1 numeric,
    var_neut_mag_1 numeric,
    var_net_mag_1 numeric,
    var_phsa_mag_1 numeric,
    var_phsb_mag_1 numeric,
    var_phsc_mag_1 numeric,
    w_neut_mag_1 numeric,
    w_net_mag_1 numeric,
    w_phsa_mag_1 numeric,
    w_phsb_mag_1 numeric,
    w_phsc_mag_1 numeric
);

SELECT create_hypertable('openfmb.data', by_range('timestamp'), if_not_exists => TRUE);

CREATE MATERIALIZED VIEW openfmb.siemens48_hour_by_hour(time, value)
  with (timescaledb.continuous) as
SELECT time_bucket('01:00:00', openfmb.data.timestamp, 'UTC') AS "time",
    round((last(phv_net_mag, 'timestamp') - first(phv_net_mag, 'timestamp')) * 100.) / 100. AS phv_net_mag
FROM openfmb.data
WHERE device_uuid = '0706D5D7-6BB0-41D1-AECF-ED3D8363E4B9'
GROUP BY 1;

SELECT add_continuous_aggregate_policy('openfmb.siemens48_hour_by_hour',
   start_offset => NULL,
   end_offset => INTERVAL '1 hour',
   schedule_interval => INTERVAL '1 hour');

CREATE MATERIALIZED VIEW openfmb.siemens40_hour_by_hour(time, value)
  with (timescaledb.continuous) as
SELECT time_bucket('01:00:00', openfmb.data.timestamp, 'UTC') AS "time",
    round((last(phv_net_mag, 'timestamp') - first(phv_net_mag, 'timestamp')) * 100.) / 100. AS phv_net_mag
FROM openfmb.data
WHERE device_uuid = 'F992EDDA-E80D-45C8-B9D5-7323106D42F4'
GROUP BY 1;

SELECT add_continuous_aggregate_policy('openfmb.siemens40_hour_by_hour',
   start_offset => NULL,
   end_offset => INTERVAL '1 hour',
   schedule_interval => INTERVAL '1 hour');

CREATE MATERIALIZED VIEW openfmb.abb48_hour_by_hour(time, value)
  with (timescaledb.continuous) as
SELECT time_bucket('01:00:00', openfmb.data.timestamp, 'UTC') AS "time",
    round((last(phv_net_mag, 'timestamp') - first(phv_net_mag, 'timestamp')) * 100.) / 100. AS phv_net_mag
FROM openfmb.data
WHERE device_uuid = '6EDCC07F-63F5-4771-B3A2-7B10A20896B9'
GROUP BY 1;

SELECT add_continuous_aggregate_policy('openfmb.abb48_hour_by_hour',
   start_offset => NULL,
   end_offset => INTERVAL '1 hour',
   schedule_interval => INTERVAL '1 hour');

CREATE MATERIALIZED VIEW openfmb.wallbox48_hour_by_hour(time, value)
  with (timescaledb.continuous) as
SELECT time_bucket('01:00:00', openfmb.data.timestamp, 'UTC') AS "time",
    round((last(phv_net_mag, 'timestamp') - first(phv_net_mag, 'timestamp')) * 100.) / 100. AS phv_net_mag
FROM openfmb.data
WHERE device_uuid = '3F776F78-6382-44C1-9B09-F6822FDBEB1B'
GROUP BY 1;

SELECT add_continuous_aggregate_policy('openfmb.wallbox48_hour_by_hour',
   start_offset => NULL,
   end_offset => INTERVAL '1 hour',
   schedule_interval => INTERVAL '1 hour');

CREATE MATERIALIZED VIEW openfmb.grizzle40_hour_by_hour(time, value)
  with (timescaledb.continuous) as
SELECT time_bucket('01:00:00', openfmb.data.timestamp, 'UTC') AS "time",
    round((last(phv_net_mag, 'timestamp') - first(phv_net_mag, 'timestamp')) * 100.) / 100. AS phv_net_mag
FROM openfmb.data
WHERE device_uuid = '22921BFD-5495-4E46-BAB7-2BFD99EDE938'
GROUP BY 1;

SELECT add_continuous_aggregate_policy('openfmb.grizzle40_hour_by_hour',
   start_offset => NULL,
   end_offset => INTERVAL '1 hour',
   schedule_interval => INTERVAL '1 hour');

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA openfmb TO openfmb_user;
GRANT USAGE ON SCHEMA openfmb TO openfmb_user;
