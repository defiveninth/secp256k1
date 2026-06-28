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
        .map(p => {
          return {
            id: p.id,
            restaurantId: p.restaurantId,
            photoUrl: p.photoUrl.startsWith('/') ? `${req.protocol}://${req.get('host')}${p.photoUrl}` : p.photoUrl
          };
        });
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
    const photos = db.prepare('SELECT id, restaurantId, photoUrl FROM restaurant_photos WHERE restaurantId = ?').all(id);
    restaurant.photos = photos.map(p => {
      return {
        id: p.id,
        restaurantId: p.restaurantId,
        photoUrl: p.photoUrl.startsWith('/') ? `${req.protocol}://${req.get('host')}${p.photoUrl}` : p.photoUrl
      };
    });

    // Fetch menu
    const menuItems = db.prepare('SELECT * FROM menu WHERE restaurantId = ?').all(id);
    restaurant.menu = menuItems.map(item => {
      return {
        ...item,
        photoUrl: item.photoUrl && item.photoUrl.startsWith('/') ? `${req.protocol}://${req.get('host')}${item.photoUrl}` : item.photoUrl
      };
    });

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
    const formattedMenuItems = menuItems.map(item => {
      return {
        ...item,
        photoUrl: item.photoUrl && item.photoUrl.startsWith('/') ? `${req.protocol}://${req.get('host')}${item.photoUrl}` : item.photoUrl
      };
    });
    return res.json(formattedMenuItems);
  } catch (error) {
    console.error(`Error fetching menu for restaurant ${id}:`, error);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
