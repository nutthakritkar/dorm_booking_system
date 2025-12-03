-- Create a new booking
CREATE OR REPLACE FUNCTION create_booking(
    p_tenant_id INT,
    p_room_id INT,
    p_start_date DATE,
    p_end_date DATE
) RETURNS TEXT AS $$
DECLARE
    v_status VARCHAR;
BEGIN
    -- Check room status
    SELECT r.status INTO v_status
    FROM rooms r
    WHERE r.room_id = p_room_id;

    IF NOT FOUND THEN
        RETURN 'Error: Room does not exist';
    ELSIF v_status <> 'available' THEN
        RETURN 'Error: Room is not available';
    END IF;

    -- Insert booking
    INSERT INTO bookings (tenant_id, room_id, start_date, end_date)
    VALUES (p_tenant_id, p_room_id, p_start_date, p_end_date);

    -- Update room status
    UPDATE rooms
    SET status = 'occupied'
    WHERE room_id = p_room_id;

    RETURN 'Booking created successfully';
END;
$$ LANGUAGE plpgsql;

-- Cancel an existing booking
CREATE OR REPLACE FUNCTION cancel_booking(p_booking_id INT)
RETURNS TEXT AS $$
DECLARE
    v_room INT;
BEGIN
    -- Find the room of the booking
    SELECT b.room_id INTO v_room
    FROM bookings b
    WHERE b.booking_id = p_booking_id;

    IF NOT FOUND THEN
        RETURN 'Error: Booking not found';
    END IF;

    -- Delete booking
    DELETE FROM bookings
    WHERE booking_id = p_booking_id;

    -- Update room status
    UPDATE rooms
    SET status = 'available'
    WHERE room_id = v_room;

    RETURN 'Booking cancelled';
END;
$$ LANGUAGE plpgsql;

-- Get all bookings for a tenant
CREATE OR REPLACE FUNCTION get_bookings_by_tenant(p_tenant_id INT)
RETURNS TABLE(
    booking_id INT,
    room_number VARCHAR,
    start_date DATE,
    end_date DATE,
    status VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT b.booking_id,
           r.room_number,
           b.start_date,
           b.end_date,
           r.status
    FROM bookings b
    JOIN rooms r ON b.room_id = r.room_id
    WHERE b.tenant_id = p_tenant_id
    ORDER BY b.start_date;
END;
$$ LANGUAGE plpgsql;
