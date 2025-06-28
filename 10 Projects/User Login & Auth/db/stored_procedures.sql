-- Stored Procedures for User Authentication System

USE auth_system;

-- Drop existing procedures if they exist
DROP PROCEDURE IF EXISTS sp_log_login;
DROP PROCEDURE IF EXISTS sp_get_user_permissions;
DROP PROCEDURE IF EXISTS sp_create_user;

-- Stored Procedure for Login Audit
DELIMITER //
CREATE PROCEDURE sp_log_login(
    IN p_user_id INT,
    IN p_success BOOLEAN,
    IN p_ip_address VARCHAR(45),
    IN p_user_agent TEXT
)
BEGIN
    INSERT INTO login_log (user_id, success, ip_address, user_agent)
    VALUES (p_user_id, p_success, p_ip_address, p_user_agent);
    
    SELECT LAST_INSERT_ID() as log_id;
END //
DELIMITER ;

-- Stored Procedure to Get User Permissions
DELIMITER //
CREATE PROCEDURE sp_get_user_permissions(
    IN p_user_id INT
)
BEGIN
    SELECT DISTINCT p.id, p.name, p.description
    FROM permissions p
    JOIN role_permissions rp ON p.id = rp.permission_id
    JOIN users u ON u.role_id = rp.role_id
    WHERE u.id = p_user_id AND u.is_active = TRUE;
END //
DELIMITER ;

-- Stored Procedure to Create User
DELIMITER //
CREATE PROCEDURE sp_create_user(
    IN p_username VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_password_hash VARCHAR(255),
    IN p_role_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    INSERT INTO users (username, email, password_hash, role_id)
    VALUES (p_username, p_email, p_password_hash, p_role_id);
    
    SELECT LAST_INSERT_ID() as user_id;
    
    COMMIT;
END //
DELIMITER ; 