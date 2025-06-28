-- Seed Data for User Authentication System

USE auth_system;

-- Insert roles
INSERT INTO roles (name, description) VALUES
('admin', 'Administrator with full access'),
('user', 'Regular user with basic access'),
('moderator', 'Moderator with limited admin access');

-- Insert permissions
INSERT INTO permissions (name, description) VALUES
('read_users', 'Can view user list'),
('create_users', 'Can create new users'),
('update_users', 'Can update user information'),
('delete_users', 'Can delete users'),
('read_logs', 'Can view login logs'),
('manage_roles', 'Can manage roles and permissions'),
('access_admin', 'Can access admin panel');

-- Assign permissions to roles
-- Admin gets all permissions
INSERT INTO role_permissions (role_id, permission_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7);

-- User gets basic permissions
INSERT INTO role_permissions (role_id, permission_id) VALUES
(2, 1);

-- Moderator gets moderate permissions
INSERT INTO role_permissions (role_id, permission_id) VALUES
(3, 1), (3, 2), (3, 3), (3, 5); 