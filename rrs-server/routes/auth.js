const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../db');
const { JWT_SECRET } = require('../middleware/auth');

const router = express.Router();

// 1. POST /auth/check
router.post('/check', (req, res) => {
  const { email } = req.body;

  if (!email) {
    return res.status(400).json({ error: 'Email is required' });
  }

  try {
    const user = db.prepare('SELECT id FROM users WHERE email = ?').get(email);

    if (user) {
      return res.json({ exists: true });
    }

    // Mock sending OTP '123456'
    const otp = '123456';
    
    // Save to otps table (upserting if it already exists for this email)
    const upsertStmt = db.prepare(`
      INSERT INTO otps (email, otp, created_at)
      VALUES (?, ?, CURRENT_TIMESTAMP)
      ON CONFLICT(email) DO UPDATE SET
        otp = excluded.otp,
        created_at = CURRENT_TIMESTAMP
    `);
    upsertStmt.run(email, otp);

    return res.json({
      exists: false,
      message: 'OTP sent to email'
    });
  } catch (error) {
    console.error('Error in /check:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

// 2. POST /auth/sign-up
router.post('/sign-up', (req, res) => {
  const { email, otp, fullname } = req.body;
  // Support both "new password" (with space as requested) and "new_password" or "password"
  const password = req.body['new password'] || req.body.new_password || req.body.password;

  if (!email || !otp || !password || !fullname) {
    return res.status(400).json({
      error: 'Missing required fields: email, otp, new password, and fullname are required'
    });
  }

  try {
    // Verify OTP
    const storedOtpRecord = db.prepare('SELECT otp FROM otps WHERE email = ?').get(email);

    if (!storedOtpRecord || storedOtpRecord.otp !== otp) {
      return res.status(400).json({ error: 'Invalid or expired OTP' });
    }

    // Hash the password
    const hashedPassword = bcrypt.hashSync(password, 10);

    // Insert new user
    const insertStmt = db.prepare(`
      INSERT INTO users (email, password, fullname)
      VALUES (?, ?, ?)
    `);
    
    let userId;
    try {
      const info = insertStmt.run(email, hashedPassword, fullname);
      userId = info.lastInsertRowid;
    } catch (dbError) {
      if (dbError.code === 'SQLITE_CONSTRAINT_UNIQUE') {
        return res.status(400).json({ error: 'User with this email already exists' });
      }
      throw dbError;
    }

    // Clear the OTP
    db.prepare('DELETE FROM otps WHERE email = ?').run(email);

    // Generate JWT token
    const token = jwt.sign({ id: userId, email }, JWT_SECRET, { expiresIn: '7d' });

    return res.status(201).json({
      success: true,
      message: 'User registered successfully',
      token,
      user: {
        id: userId,
        email,
        fullname
      }
    });
  } catch (error) {
    console.error('Error in /sign-up:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

// 3. POST /auth/sign-in
router.post('/sign-in', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'Email and password are required' });
  }

  try {
    const user = db.prepare('SELECT * FROM users WHERE email = ?').get(email);

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Verify password
    const isPasswordCorrect = bcrypt.compareSync(password, user.password);

    if (!isPasswordCorrect) {
      return res.status(401).json({ error: 'Invalid password' });
    }

    // Generate JWT token
    const token = jwt.sign({ id: user.id, email: user.email }, JWT_SECRET, { expiresIn: '7d' });

    return res.json({
      success: true,
      token,
      user: {
        id: user.id,
        email: user.email,
        fullname: user.fullname
      }
    });
  } catch (error) {
    console.error('Error in /sign-in:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
