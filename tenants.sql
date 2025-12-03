-- Get all rooms in the dorm
CREATE OR REPLACE FUNCTION get_all_rooms()
RETURNS TABLE(room_id INT, room_number VARCHAR, capacity INT, status VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT room_id, room_number, capacity, status
    FROM rooms
    ORDER BY room_id;
END; $$ LANGUAGE plpgsql;

-- Get the available rooms
CREATE OR REPLACE FUNCTION get_available_rooms()
RETURNS TABLE(room_id INT, room_number VARCHAR, capacity INT) AS $$
BEGIN
    RETURN QUERY
    SELECT room_id, room_number, capacity
    FROM rooms
    WHERE status = 'available'
    ORDER BY room_id;
END; $$ LANGUAGE plpgsql;

-- Add new rooms
CREATE OR REPLACE FUNCTION add_room(
    p_room_number VARCHAR,
    p_capacity INT
) RETURNS TEXT AS $$
BEGIN
    INSERT INTO rooms (room_number, capacity, status)
    VALUES (p_room_number, p_capacity, 'available');

    RETURN 'Room added successfully';
END; $$ LANGUAGE plpgsql;

-- Update room status
CREATE OR REPLACE FUNCTION update_room_status(
    p_room_id INT,
    p_status VARCHAR
) RETURNS TEXT AS $$
BEGIN
    UPDATE rooms SET status = p_status WHERE room_id = p_room_id;

    IF NOT FOUND THEN
        RETURN 'Error: Room not found';
    END IF;

    RETURN 'Room status updated';
END; $$ LANGUAGE plpgsql;
