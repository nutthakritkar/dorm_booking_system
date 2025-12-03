-- Get email of current user
CREATE OR REPLACE FUNCTION login_user(p_email VARCHAR)
RETURNS TABLE(tenant_id INT, name VARCHAR, email VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT t.tenant_id AS tenant_id,
           t.name AS name,
           t.email AS email
    FROM tenants t
    WHERE t.email = p_email;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_tenant(
    p_name VARCHAR,
    p_email VARCHAR
) RETURNS TEXT AS $$
BEGIN
    INSERT INTO tenants (name, email)
    VALUES (p_name, p_email);

    RETURN 'Tenant added successfully';
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_email_exists(p_email VARCHAR)
RETURNS BOOLEAN AS $$
DECLARE v_exists BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM tenants WHERE email = p_email)
    INTO v_exists;

    RETURN v_exists;
END; $$ LANGUAGE plpgsql;
