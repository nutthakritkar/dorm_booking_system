CREATE OR REPLACE FUNCTION booking_report_month(
    p_year INT,
    p_month INT
)
RETURNS TABLE(
    room_number VARCHAR,
    tenant_name VARCHAR,
    start_date DATE,
    end_date DATE
) AS $$
BEGIN
    RETURN QUERY
    SELECT r.room_number, t.name, b.start_date, b.end_date
    FROM bookings b
    JOIN tenants t ON t.tenant_id = b.tenant_id
    JOIN rooms r ON r.room_id = b.room_id
    WHERE EXTRACT(YEAR FROM b.start_date) = p_year
      AND EXTRACT(MONTH FROM b.start_date) = p_month
    ORDER BY r.room_number;
END; $$ LANGUAGE plpgsql;
