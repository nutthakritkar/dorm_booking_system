-- Drop tables if they exist
DROP TABLE IF EXISTS bookings CASCADE;
DROP TABLE IF EXISTS tenants CASCADE;
DROP TABLE IF EXISTS rooms CASCADE;

-- Create rooms table
CREATE TABLE rooms (
    room_id INT PRIMARY KEY,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    capacity INT NOT NULL,
    status VARCHAR(20) DEFAULT 'available'
);

-- Create tenants table
CREATE TABLE tenants (
    tenant_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    phone VARCHAR(20)
);

-- Create bookings table
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    tenant_id INT REFERENCES tenants(tenant_id),
    room_id INT REFERENCES rooms(room_id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

-- Insert rooms with explicit room_id
INSERT INTO rooms (room_id, room_number, capacity) VALUES
(101, '101', 2), (102, '102', 2), (103, '103', 3), (104, '104', 1), (105, '105', 2),
(201, '201', 3), (202, '202', 2), (203, '203', 1), (204, '204', 2), (205, '205', 3);

-- Insert tenants
INSERT INTO tenants (name, email, phone) VALUES
('Alice', 'alice@example.com', '0812345670'),
('Bob', 'bob@example.com', '0812345671'),
('Charlie', 'charlie@example.com', '0812345672'),
('Diana', 'diana@example.com', '0812345673'),
('Eve', 'eve@example.com', '0812345674'),
('Frank', 'frank@example.com', '0812345675'),
('Grace', 'grace@example.com', '0812345676'),
('Hank', 'hank@example.com', '0812345677'),
('Ivy', 'ivy@example.com', '0812345678'),
('Jack', 'jack@example.com', '0812345679');

-- Insert bookings (room_id now matches rooms)
INSERT INTO bookings (tenant_id, room_id, start_date, end_date) VALUES
(1, 101, '2025-12-05', '2025-12-15'),
(2, 102, '2025-12-06', '2025-12-16'),
(3, 103, '2025-12-07', '2025-12-17'),
(4, 104, '2025-12-08', '2025-12-18'),
(5, 105, '2025-12-09', '2025-12-19'),
(6, 201, '2025-12-10', '2025-12-20'),
(7, 202, '2025-12-11', '2025-12-21'),
(8, 203, '2025-12-12', '2025-12-22'),
(9, 204, '2025-12-13', '2025-12-23'),
(10, 205, '2025-12-14', '2025-12-24');

