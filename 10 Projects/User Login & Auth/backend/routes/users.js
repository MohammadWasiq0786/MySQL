const express = require('express');
const { verifyToken, checkPermission, requireAdmin } = require('../middleware/auth');
const { pool } = require('../config/database');

const router = express.Router();

// Get all users (admin only)
router.get('/', verifyToken, checkPermission('read_users'), async (req, res) => {
  try {
    const [users] = await pool.execute(
      `SELECT u.id, u.username, u.email, u.is_active, u.created_at, r.name as role_name
       FROM users u 
       JOIN roles r ON u.role_id = r.id 
       ORDER BY u.created_at DESC`
    );

    res.json({ users });
  } catch (error) {
    console.error('Get users error:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// Get login logs (admin only)
router.get('/logs', verifyToken, checkPermission('read_logs'), async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 50;
    const offset = (page - 1) * limit;

    const [logs] = await pool.execute(
      `SELECT ll.id, ll.login_time, ll.success, ll.ip_address, ll.user_agent,
              u.username, u.email
       FROM login_log ll
       LEFT JOIN users u ON ll.user_id = u.id
       ORDER BY ll.login_time DESC
       LIMIT ? OFFSET ?`,
      [limit, offset]
    );

    const [totalCount] = await pool.execute('SELECT COUNT(*) as total FROM login_log');
    const total = totalCount[0].total;

    res.json({
      logs,
      pagination: {
        page,
        limit,
        total,
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    console.error('Get logs error:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// Get user by ID
router.get('/:id', verifyToken, checkPermission('read_users'), async (req, res) => {
  try {
    const [users] = await pool.execute(
      `SELECT u.id, u.username, u.email, u.is_active, u.created_at, r.name as role_name
       FROM users u 
       JOIN roles r ON u.role_id = r.id 
       WHERE u.id = ?`,
      [req.params.id]
    );

    if (users.length === 0) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.json({ user: users[0] });
  } catch (error) {
    console.error('Get user error:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// Update user role (admin only)
router.patch('/:id/role', verifyToken, requireAdmin, async (req, res) => {
  try {
    const { role_id } = req.body;

    if (!role_id || !Number.isInteger(parseInt(role_id))) {
      return res.status(400).json({ message: 'Valid role_id is required' });
    }

    const [result] = await pool.execute(
      'UPDATE users SET role_id = ? WHERE id = ?',
      [role_id, req.params.id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.json({ message: 'User role updated successfully' });
  } catch (error) {
    console.error('Update user role error:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// Toggle user active status (admin only)
router.patch('/:id/status', verifyToken, requireAdmin, async (req, res) => {
  try {
    const [result] = await pool.execute(
      'UPDATE users SET is_active = NOT is_active WHERE id = ?',
      [req.params.id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.json({ message: 'User status updated successfully' });
  } catch (error) {
    console.error('Update user status error:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// Get all roles (public)
router.get('/roles/list', async (req, res) => {
  try {
    const [roles] = await pool.execute(
      'SELECT id, name, description FROM roles ORDER BY name'
    );

    res.json({ roles });
  } catch (error) {
    console.error('Get roles error:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// Get user permissions
router.get('/permissions/me', verifyToken, async (req, res) => {
  try {
    const [permissions] = await pool.execute(
      'CALL sp_get_user_permissions(?)',
      [req.user.id]
    );

    res.json({ permissions: permissions[0] });
  } catch (error) {
    console.error('Get permissions error:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

module.exports = router; 