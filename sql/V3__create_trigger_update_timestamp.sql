-- V3: Trigger function + trigger

CREATE FUNCTION app.set_updated_at()
RETURNS trigger AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_set_updated_at
BEFORE UPDATE ON app.users
FOR EACH ROW
EXECUTE FUNCTION app.set_updated_at();
