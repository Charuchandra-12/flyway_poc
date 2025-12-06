-- V1: Create schema, sequence, and table (super simple)

CREATE SCHEMA app;

CREATE SEQUENCE app.users_id_seq;

CREATE TABLE app.users (
  id BIGINT PRIMARY KEY DEFAULT nextval('app.users_id_seq'),
  username TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);
