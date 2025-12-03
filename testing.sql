SELECT * FROM get_all_rooms();
SELECT * FROM get_available_rooms();
SELECT create_booking(1, 101, '2025-12-20', '2025-12-25');
SELECT * FROM login_user('alice@example.com');
SELECT * FROM tenants;
SELECT * FROM bookings;
SELECT create_booking(1, 999, '2025-12-20', '2025-12-25');
SELECT create_booking(1, 101, '2025-12-20', '2025-12-25');
SELECT add_room(301,'301', 2);
SELECT update_room_status(101, 'occupied');


