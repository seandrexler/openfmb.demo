CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE; -- https://stackoverflow.com/a/49111932/3192769

CREATE USER openfmb_user WITH PASSWORD 'password';

CREATE SCHEMA openfmb;

DROP TABLE IF EXISTS openfmb.raw_data;

CREATE TABLE openfmb.raw_data
(
    message_uuid uuid NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    device_uuid uuid NOT NULL,
    tagname TEXT NOT NULL,
    value jsonb NOT NULL
);

CREATE TABLE openfmb.data
(
    message_uuid uuid NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    device_uuid uuid NOT NULL,
    tagname TEXT NOT NULL,
    pf_net_ang numeric,
    pf_net_mag numeric,
    phv_net_mag numeric,
    phv_net_ang numeric,
    var_net_ang numeric,
    var_net_mag numeric,
    w_net_ang numeric,
    w_net_mag numeric
);

SELECT create_hypertable('openfmb.data', by_range('timestamp', INTERVAL '1 day'), if_not_exists => TRUE);

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA openfmb TO openfmb_user;
GRANT USAGE ON SCHEMA openfmb TO openfmb_user;
