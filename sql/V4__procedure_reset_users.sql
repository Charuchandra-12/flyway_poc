-- V4: Stored procedure

CREATE PROCEDURE app.reset_users()
LANGUAGE plpgsql
AS $$
BEGIN
  DELETE FROM app.users;
END;
$$;
