const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { body, validationResult } = require('express-validator');
const { pool } = require('../config/database');
const { verifyToken } = require('../middleware/auth');

const router = express.Router();

// Register new user
router.post('/register', [
  body('username').isLength({ min: 3 }).trim().escape(),
  body('email').isEmail().normalizeEmail(),
  body('password').isLength({ min: 6 }),
  body('role_id').isInt({ min: 1 })
], async (req, res) => {
  try {
    // Check validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { username, email, password, role_id } = req.body;

    // Check if user already exists
    const [existingUsers] = await pool.execute(
      'SELECT id FROM users WHERE username = ? OR email = ?',
      [username, email]
    );

    if (existingUsers.length > 0) {
      return res.status(400).json({ message: 'Username or email already exists' });
    }

    // Hash password
    const saltRounds = 12;
    const passwordHash = await bcrypt.hash(password, saltRounds);

    // Create user using stored procedure
    const [result] = await pool.execute(
      'CALL sp_create_user(?, ?, ?, ?)',
      [username, email, passwordHash, role_id]
    );

    const userId = result[0][0].user_id;

    // Generate JWT token
    const token = jwt.sign(
      { id: userId, username, role_id },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN }
    );

    res.status(201).json({
      message: 'User registered successfully',
      token,
      user: { id: userId, username, email, role_id }
    });

  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// Login user
router.post('/login', [
  body('username').notEmpty().trim().escape(),
  body('password').notEmpty()
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { username, password } = req.body;
    const ipAddress = req.ip || req.connection.remoteAddress;
    const userAgent = req.get('User-Agent');

    // Find user
    const [users] = await pool.execute(
      `SELECT u.id, u.username, u.email, u.password_hash, u.role_id, r.name as role_name 
       FROM users u 
       JOIN roles r ON u.role_id = r.id 
       WHERE u.username = ? AND u.is_active = TRUE`,
      [username]
    );

    if (users.length === 0) {
      // Log failed login attempt
      await pool.execute(
        'CALL sp_log_login(?, ?, ?, ?)',
        [null, false, ipAddress, userAgent]
      );
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const user = users[0];

    // Verify password
    const isValidPassword = await bcrypt.compare(password, user.password_hash);
    
    if (!isValidPassword) {
      // Log failed login attempt
      await pool.execute(
        'CALL sp_log_login(?, ?, ?, ?)',
        [user.id, false, ipAddress, userAgent]
      );
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    // Log successful login
    await pool.execute(
      'CALL sp_log_login(?, ?, ?, ?)',
      [user.id, true, ipAddress, userAgent]
    );

    // Generate JWT token
    const token = jwt.sign(
      { id: user.id, username: user.username, role_id: user.role_id },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN }
    );

    res.json({
      message: 'Login successful',
      token,
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        role: user.role_name
      }
    });

  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// Get current user profile
router.get('/profile', verifyToken, async (req, res) => {
  try {
    const [users] = await pool.execute(
      `SELECT u.id, u.username, u.email, u.created_at, r.name as role_name
       FROM users u 
       JOIN roles r ON u.role_id = r.id 
       WHERE u.id = ?`,
      [req.user.id]
    );

    if (users.length === 0) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.json({ user: users[0] });
  } catch (error) {
    console.error('Profile error:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

module.exports = router; 