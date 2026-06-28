const express = require('express');
const db = require('../db');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// Helper to normalize "9:00" to "09:00" and trim whitespace
function normalizeTimeSlot(timeStr) {
  if (!timeStr) return null;
  const cleaned = timeStr.trim();
  const parts = cleaned.split(':');
  if (parts.length !== 2) return null;
  const hour = parts[0].padStart(2, '0');
  const minute = parts[1].padStart(2, '0');
  return `${hour}:${minute}`;
}

// Helper to validate format (strict HH:00 or HH:30 in 24h format)
function isValidTimeSlot(timeStr) {
  return /^([0-1]\d|2[0-3]):(00|30)$/.test(timeStr);
}

// Helper to convert time string (12h AM/PM or 24h) to minutes since midnight
function parseTimeToMinutes(timeStr) {
  if (!timeStr) return null;
  timeStr = timeStr.trim().toUpperCase();

  const is12Hour = timeStr.includes('AM') || timeStr.includes('PM');
  if (is12Hour) {
    const match = timeStr.match(/^(\d+):(\d+)\s*(AM|PM)$/);
    if (!match) return null;
    let hours = parseInt(match[1], 10);
    const minutes = parseInt(match[2], 10);
    const ampm = match[3];

    if (ampm === 'PM' && hours !== 12) hours += 12;
    if (ampm === 'AM' && hours === 12) hours = 0;

    return hours * 60 + minutes;
  } else {
    const parts = timeStr.split(':');
    if (parts.length !== 2) return null;
    const hours = parseInt(parts[0], 10);
    const minutes = parseInt(parts[1], 10);
    return hours * 60 + minutes;
  }
}

// Helper to validate if a reservation time is within the operating hours of a restaurant
function isTimeWithinOperatingHours(resTimeStr, openTimeStr, closeTimeStr) {
  // If openTime and closeTime are both 00:00, it's 24/7
  const normOpen = normalizeTimeSlot(openTimeStr);
  const normClose = normalizeTimeSlot(closeTimeStr);
  if (normOpen === '00:00' && normClose === '00:00') {
    return true;
  }

  const resMin = parseTimeToMinutes(resTimeStr);
  const openMin = parseTimeToMinutes(openTimeStr);
  const closeMin = parseTimeToMinutes(closeTimeStr);

  if (resMin === null || openMin === null || closeMin === null) {
    return false;
  }

  if (closeMin >= openMin) {
    // Normal operation (e.g. 09:00 to 22:00)
    return resMin >= openMin && resMin <= closeMin;
  } else {
    // Overnight operation (e.g. 18:00 to 02:00)
    return resMin >= openMin || resMin <= closeMin;
  }
}

// Helper to validate preOrderList format ({ itemId: count })
function validatePreOrderList(preOrderList) {
  if (preOrderList === undefined) {
    return { valid: true, valueStr: '{}' };
  }
  if (typeof preOrderList !== 'object' || preOrderList === null || Array.isArray(preOrderList)) {
    return { valid: false, error: 'preOrderList must be a JSON object of { itemId: count }' };
  }
  
  // Verify each key/value is numeric/integer and count is positive
  const sanitized = {};
  for (const [key, val] of Object.entries(preOrderList)) {
    const itemId = parseInt(key, 10);
    const count = parseInt(val, 10);
    if (isNaN(itemId) || isNaN(count) || count <= 0) {
      return { valid: false, error: 'preOrderList keys must be numeric item IDs and values must be positive integers' };
    }
    sanitized[itemId] = count;
  }
  return { valid: true, valueStr: JSON.stringify(sanitized) };
}

// 1. POST /reservations - Create reservation
router.post('/', authenticateToken, (req, res) => {
  const { restaurantId, time, day, preOrderList } = req.body;
  const userId = req.user.id;

  if (!restaurantId || !time || !day) {
    return res.status(400).json({ error: 'Missing required fields: restaurantId, time, and day are required' });
  }

  // Validate day format (YYYY-MM-DD)
  if (!/^\d{4}-\d{2}-\d{2}$/.test(day)) {
    return res.status(400).json({ error: 'Day must be in YYYY-MM-DD format' });
  }

  // Normalize and validate strict time slot
  const normalizedTime = normalizeTimeSlot(time);
  if (!normalizedTime || !isValidTimeSlot(normalizedTime)) {
    return res.status(400).json({ error: 'Time must be a strict 30-minute slot (e.g. 10:00, 10:30, 11:00) in 24h format' });
  }

  // Validate preOrderList
  const preOrderValidation = validatePreOrderList(preOrderList);
  if (!preOrderValidation.valid) {
    return res.status(400).json({ error: preOrderValidation.error });
  }
  const preOrderListStr = preOrderValidation.valueStr;

  try {
    // Check if restaurant exists and fetch its operating hours
    const restaurant = db.prepare('SELECT * FROM restaurants WHERE id = ?').get(restaurantId);
    if (!restaurant) {
      return res.status(404).json({ error: 'Restaurant not found' });
    }

    // Verify operating hours
    const isWorking = isTimeWithinOperatingHours(normalizedTime, restaurant.openTime, restaurant.closeTime);
    if (!isWorking) {
      return res.status(400).json({
        error: `Restaurant is closed at the requested time. Operating hours: ${restaurant.openTime} - ${restaurant.closeTime}`
      });
    }

    // Check if duplicate reservation exists for this user at this slot
    const duplicate = db.prepare(`
      SELECT id FROM reservations 
      WHERE userId = ? AND restaurantId = ? AND time = ? AND day = ?
    `).get(userId, restaurantId, normalizedTime, day);

    if (duplicate) {
      return res.status(400).json({ error: 'You already have a reservation at this time slot' });
    }

    const insertStmt = db.prepare(`
      INSERT INTO reservations (userId, restaurantId, time, day, preOrderList)
      VALUES (?, ?, ?, ?, ?)
    `);
    const info = insertStmt.run(userId, restaurantId, normalizedTime, day, preOrderListStr);

    return res.status(201).json({
      success: true,
      reservation: {
        id: info.lastInsertRowid,
        userId,
        restaurantId,
        time: normalizedTime,
        day,
        preOrderList: JSON.parse(preOrderListStr)
      }
    });
  } catch (error) {
    console.error('Error creating reservation:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

// 2. GET /reservations - Get all reservations for the authenticated user
router.get('/', authenticateToken, (req, res) => {
  const userId = req.user.id;

  try {
    const reservations = db.prepare(`
      SELECT r.id, r.userId, r.restaurantId, r.time, r.day, r.preOrderList, r.created_at,
             rest.name AS restaurantName, rest.location AS restaurantLocation
      FROM reservations r
      JOIN restaurants rest ON r.restaurantId = rest.id
      WHERE r.userId = ?
      ORDER BY r.day ASC, r.time ASC
    `).all(userId);

    // Map photoUrls for each restaurant as well
    const photos = db.prepare('SELECT * FROM restaurant_photos').all();

    const reservationsWithDetails = reservations.map(r => {
      r.restaurantPhotos = photos
        .filter(p => p.restaurantId === r.restaurantId)
        .map(p => p.photoUrl);
      r.preOrderList = JSON.parse(r.preOrderList || '{}');
      return r;
    });

    return res.json(reservationsWithDetails);
  } catch (error) {
    console.error('Error fetching reservations:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

// 3. GET /reservations/:id - Get a single reservation details
router.get('/:id', authenticateToken, (req, res) => {
  const { id } = req.params;
  const userId = req.user.id;

  try {
    const reservation = db.prepare(`
      SELECT r.id, r.userId, r.restaurantId, r.time, r.day, r.preOrderList, r.created_at,
             rest.name AS restaurantName, rest.location AS restaurantLocation,
             rest.openTime, rest.closeTime, rest.contactPhoneNumber
      FROM reservations r
      JOIN restaurants rest ON r.restaurantId = rest.id
      WHERE r.id = ?
    `).get(id);

    if (!reservation) {
      return res.status(404).json({ error: 'Reservation not found' });
    }

    // Verify ownership
    if (reservation.userId !== userId) {
      return res.status(403).json({ error: 'Forbidden: You do not own this reservation' });
    }

    const photos = db.prepare('SELECT photoUrl FROM restaurant_photos WHERE restaurantId = ?').all(reservation.restaurantId);
    reservation.restaurantPhotos = photos.map(p => p.photoUrl);
    reservation.preOrderList = JSON.parse(reservation.preOrderList || '{}');

    return res.json(reservation);
  } catch (error) {
    console.error(`Error fetching reservation ${id}:`, error);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

// 4. PUT /reservations/:id - Update reservation
router.put('/:id', authenticateToken, (req, res) => {
  const { id } = req.params;
  const { time, day, preOrderList } = req.body;
  const userId = req.user.id;

  if (!time || !day) {
    return res.status(400).json({ error: 'Missing required fields: time and day are required' });
  }

  // Validate day format (YYYY-MM-DD)
  if (!/^\d{4}-\d{2}-\d{2}$/.test(day)) {
    return res.status(400).json({ error: 'Day must be in YYYY-MM-DD format' });
  }

  // Normalize and validate strict time slot
  const normalizedTime = normalizeTimeSlot(time);
  if (!normalizedTime || !isValidTimeSlot(normalizedTime)) {
    return res.status(400).json({ error: 'Time must be a strict 30-minute slot (e.g. 10:00, 10:30, 11:00) in 24h format' });
  }

  // Validate preOrderList
  const preOrderValidation = validatePreOrderList(preOrderList);
  if (!preOrderValidation.valid) {
    return res.status(400).json({ error: preOrderValidation.error });
  }
  const preOrderListStr = preOrderValidation.valueStr;

  try {
    // Fetch reservation to verify existence and ownership
    const reservation = db.prepare('SELECT * FROM reservations WHERE id = ?').get(id);
    if (!reservation) {
      return res.status(404).json({ error: 'Reservation not found' });
    }

    if (reservation.userId !== userId) {
      return res.status(403).json({ error: 'Forbidden: You do not own this reservation' });
    }

    // Fetch restaurant to verify operating hours
    const restaurant = db.prepare('SELECT * FROM restaurants WHERE id = ?').get(reservation.restaurantId);
    if (!restaurant) {
      return res.status(404).json({ error: 'Restaurant not found' });
    }

    // Verify operating hours
    const isWorking = isTimeWithinOperatingHours(normalizedTime, restaurant.openTime, restaurant.closeTime);
    if (!isWorking) {
      return res.status(400).json({
        error: `Restaurant is closed at the requested time. Operating hours: ${restaurant.openTime} - ${restaurant.closeTime}`
      });
    }

    // Update
    db.prepare(`
      UPDATE reservations 
      SET time = ?, day = ?, preOrderList = ? 
      WHERE id = ?
    `).run(normalizedTime, day, preOrderListStr, id);

    return res.json({
      success: true,
      message: 'Reservation updated successfully',
      reservation: {
        id: parseInt(id, 10),
        userId,
        restaurantId: reservation.restaurantId,
        time: normalizedTime,
        day,
        preOrderList: JSON.parse(preOrderListStr)
      }
    });
  } catch (error) {
    console.error(`Error updating reservation ${id}:`, error);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

// 5. DELETE /reservations/:id - Cancel reservation
router.delete('/:id', authenticateToken, (req, res) => {
  const { id } = req.params;
  const userId = req.user.id;

  try {
    // Fetch reservation to verify existence and ownership
    const reservation = db.prepare('SELECT * FROM reservations WHERE id = ?').get(id);
    if (!reservation) {
      return res.status(404).json({ error: 'Reservation not found' });
    }

    if (reservation.userId !== userId) {
      return res.status(403).json({ error: 'Forbidden: You do not own this reservation' });
    }

    db.prepare('DELETE FROM reservations WHERE id = ?').run(id);

    return res.json({
      success: true,
      message: 'Reservation cancelled successfully'
    });
  } catch (error) {
    console.error(`Error deleting reservation ${id}:`, error);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
