-- V4: Simple stored procedure

CREATE PROCEDURE app.reset_users()
LANGUAGE plpgsql
AS $$
BEGIN
  DELETE FROM app.users;
END;
$$;
