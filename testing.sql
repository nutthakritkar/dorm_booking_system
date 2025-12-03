SELECT * FROM public.get_all_rooms();
SELECT * FROM get_available_rooms();
SELECT create_booking(1, 101, '2025-12-20', '2025-12-25');
SELECT * FROM login_user('alice@example.com');
SELECT * FROM tenants;
SELECT * FROM bookings;
SELECT create_booking(1, 999, '2025-12-20', '2025-12-25');
SELECT create_booking(1, 101, '2025-12-20', '2025-12-25');
SELECT * FROM get_bookings_by_tenant(1);  -- replace 1 with a valid tenant_id


