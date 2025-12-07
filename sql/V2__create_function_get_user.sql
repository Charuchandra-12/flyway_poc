-- V2: Function to get user by id  

CREATE FUNCTION app.get_user_by_id(p_id BIGINT)
RETURNS TABLE(id BIGINT, username TEXT, created_at TIMESTAMPTZ) AS $$
BEGIN
  RETURN QUERY
  SELECT u.id, u.username, u.created_at
  FROM app.users u
  WHERE u.id = p_id;
END;
$$ LANGUAGE plpgsql;
