const jwt = require('jsonwebtoken');
const { pool } = require('../config/database');

// Verify JWT token
const verifyToken = async (req, res, next) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];
    
    if (!token) {
      return res.status(401).json({ message: 'Access token required' });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(401).json({ message: 'Invalid token' });
  }
};

// Check if user has specific permission
const checkPermission = (permission) => {
  return async (req, res, next) => {
    try {
      const [rows] = await pool.execute(
        'CALL sp_get_user_permissions(?)',
        [req.user.id]
      );
      
      const permissions = rows[0];
      const hasPermission = permissions.some(p => p.name === permission);
      
      if (!hasPermission) {
        return res.status(403).json({ message: 'Insufficient permissions' });
      }
      
      next();
    } catch (error) {
      console.error('Permission check error:', error);
      return res.status(500).json({ message: 'Internal server error' });
    }
  };
};

// Check if user has admin role
const requireAdmin = async (req, res, next) => {
  try {
    const [rows] = await pool.execute(
      'SELECT r.name FROM users u JOIN roles r ON u.role_id = r.id WHERE u.id = ?',
      [req.user.id]
    );
    
    if (rows.length === 0 || rows[0].name !== 'admin') {
      return res.status(403).json({ message: 'Admin access required' });
    }
    
    next();
  } catch (error) {
    console.error('Admin check error:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
};

module.exports = {
  verifyToken,
  checkPermission,
  requireAdmin
}; 