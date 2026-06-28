const express = require('express');
const db = require('../db');

const router = express.Router();

// GET /restaurants
router.get('/', (req, res) => {
  try {
    const restaurants = db.prepare('SELECT * FROM restaurants').all();
    const photos = db.prepare('SELECT * FROM restaurant_photos').all();

    const restaurantsWithPhotos = restaurants.map(r => {
      r.photos = photos
        .filter(p => p.restaurantId === r.id)
        .map(p => p.photoUrl);
      return r;
    });

    return res.json(restaurantsWithPhotos);
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

    // Fetch photos
    const photos = db.prepare('SELECT photoUrl FROM restaurant_photos WHERE restaurantId = ?').all(id);
    restaurant.photos = photos.map(p => p.photoUrl);

    // Fetch menu
    const menuItems = db.prepare('SELECT * FROM menu WHERE restaurantId = ?').all(id);
    restaurant.menu = menuItems;

    return res.json(restaurant);
  } catch (error) {
    console.error(`Error fetching restaurant ${id}:`, error);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /restaurants/:id/menu
router.get('/:id/menu', (req, res) => {
  const { id } = req.params;

  try {
    const restaurant = db.prepare('SELECT id FROM restaurants WHERE id = ?').get(id);

    if (!restaurant) {
      return res.status(404).json({ error: 'Restaurant not found' });
    }

    const menuItems = db.prepare('SELECT * FROM menu WHERE restaurantId = ?').all(id);
    return res.json(menuItems);
  } catch (error) {
    console.error(`Error fetching menu for restaurant ${id}:`, error);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
