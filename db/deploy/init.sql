-- Deploy bg-mapper:init to pg

BEGIN;

CREATE TABLE estimates (
    id SERIAL PRIMARY KEY,
    cell_id INTEGER NOT NULL,
    user_id INTEGER,
    estimate INTEGER,
    observation_time timestamp,
    notes TEXT
)

CREATE TABLE cells (
    id SERIAL PRIMARY KEY,
    geom GEOMETRY
)

COMMIT;
