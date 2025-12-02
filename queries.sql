
-- Get all rooms

CREATE OR REPLACE FUNCTION get_all_rooms()
RETURNS TABLE(
    room_id INT,
    room_number VARCHAR,
    capacity INT,
    status VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT r.room_id AS room_id,
           r.room_number AS room_number,
           r.capacity AS capacity,
           r.status AS status
    FROM rooms r
    ORDER BY r.room_id;
END;
$$ LANGUAGE plpgsql;


-- Get available rooms

CREATE OR REPLACE FUNCTION get_available_rooms()
RETURNS TABLE(
    room_id INT,
    room_number VARCHAR,
    capacity INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT r.room_id AS room_id,
           r.room_number AS room_number,
           r.capacity AS capacity
    FROM rooms r
    WHERE r.status = 'available'
    ORDER BY r.room_id;
END;
$$ LANGUAGE plpgsql;


-- Create booking

CREATE OR REPLACE FUNCTION create_booking(
    p_tenant_id INT,
    p_room_id INT,
    p_start_date DATE,
    p_end_date DATE
)
RETURNS TEXT AS $$
DECLARE
    v_room_status VARCHAR(20);
BEGIN
    -- Check if room exists and its status
    SELECT status INTO v_room_status FROM rooms WHERE room_id = p_room_id;

    IF NOT FOUND THEN
        RETURN 'Error: Room does not exist';
    ELSIF v_room_status <> 'available' THEN
        RETURN 'Error: Room is not available';
    END IF;

    -- Insert booking
    INSERT INTO bookings (tenant_id, room_id, start_date, end_date)
    VALUES (p_tenant_id, p_room_id, p_start_date, p_end_date);

    -- Update room status to occupied
    UPDATE rooms SET status = 'occupied' WHERE room_id = p_room_id;

    RETURN 'Booking created successfully';
END;
$$ LANGUAGE plpgsql;


-- Login user (simple tenant check)

CREATE OR REPLACE FUNCTION login_user(p_email VARCHAR)
RETURNS TABLE(
    tenant_id INT,
    name VARCHAR,
    email VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT t.tenant_id AS tenant_id,
           t.name AS name,
           t.email AS email
    FROM tenants t
    WHERE t.email = p_email;
END;
$$ LANGUAGE plpgsql;

-- View all rooms
SELECT * FROM get_all_rooms();

-- View available rooms
SELECT * FROM get_available_rooms();


-- Test creating a booking
SELECT create_booking(1, 101, '2025-12-20', '2025-12-25');


-- Test login_user function

SELECT * FROM login_user('alice@example.com');


-- View all tenants
SELECT * FROM tenants;


-- View all bookings

SELECT * FROM bookings;


-- Check available rooms again (after booking)
SELECT * FROM get_available_rooms();


-- Check bookings for a specific tenant
SELECT b.booking_id, r.room_number, b.start_date, b.end_date
FROM bookings b
JOIN rooms r ON b.room_id = r.room_id
WHERE b.tenant_id = 1;


-- Check bookings for a specific room

SELECT b.booking_id, t.name AS tenant_name, b.start_date, b.end_date
FROM bookings b
JOIN tenants t ON b.tenant_id = t.tenant_id
WHERE b.room_id = 101;
