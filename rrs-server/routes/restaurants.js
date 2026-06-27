const express = require('express');
const db = require('../db');

const router = express.Router();

// GET /restaurants
router.get('/', (req, res) => {
  try {
    const restaurants = db.prepare('SELECT * FROM restaurants').all();
    return res.json(restaurants);
  } catch (error) {
    console.error('Error fetching restaurants:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /restaurants/:id
router.get('/:id', (req, res) => {
  const { id } = req.params;

  try {
    const restaurant = db.prepare('SELECT * FROM restaurants WHERE id = ?').get(id);

    if (!restaurant) {
      return res.status(404).json({ error: 'Restaurant not found' });
    }

    return res.json(restaurant);
  } catch (error) {
    console.error(`Error fetching restaurant ${id}:`, error);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
