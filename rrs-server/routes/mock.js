const express = require('express');
const db = require('../db');

const router = express.Router();

const mockRestaurants = [
  {
    name: "The Gourmet Bistro",
    description: "Fine dining with a curated modern menu featuring local seasonal ingredients.",
    openTime: "11:00 AM",
    closeTime: "10:00 PM",
    location: "123 Main St, Downtown",
    photos: [
      "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4",
      "https://images.unsplash.com/photo-1550966871-3ed3cdb5ed0c",
      "https://images.unsplash.com/photo-1552566626-52f8b828add9"
    ],
    contactPhoneNumber: "+1-555-0199"
  },
  {
    name: "Pizzeria Napoli",
    description: "Authentic wood-fired Neapolitan pizza made with imported Italian ingredients.",
    openTime: "12:00 PM",
    closeTime: "11:00 PM",
    location: "456 Oak Rd, Little Italy",
    photos: [
      "https://images.unsplash.com/photo-1555396273-367ea4eb4db5",
      "https://images.unsplash.com/photo-1513104890138-7c749659a591"
    ],
    contactPhoneNumber: "+1-555-0245"
  },
  {
    name: "Sushi Sakura",
    description: "Traditional sushi bar and Japanese dishes served in a minimalist, serene space.",
    openTime: "11:30 AM",
    closeTime: "09:30 PM",
    location: "789 Pine Ave, Uptown",
    photos: [
      "https://images.unsplash.com/photo-1579871494447-9811cf80d66c",
      "https://images.unsplash.com/photo-1611143669185-af224c5e3252",
      "https://images.unsplash.com/photo-1553621042-f6e147245754"
    ],
    contactPhoneNumber: "+1-555-0312"
  },
  {
    name: "Taco Loco",
    description: "Vibrant Mexican street food, tacos, and fresh margaritas in a festive atmosphere.",
    openTime: "10:00 AM",
    closeTime: "11:00 PM",
    location: "321 Elm St, West End",
    photos: [
      "https://images.unsplash.com/photo-1565299585323-38d6b0865b47",
      "https://images.unsplash.com/photo-1582234372722-50d7ccc30e5a"
    ],
    contactPhoneNumber: "+1-555-0456"
  },
  {
    name: "The Green Bowl",
    description: "Healthy salads, grain bowls, smoothies, and plant-based options.",
    openTime: "08:00 AM",
    closeTime: "08:00 PM",
    location: "555 Maple Dr, Financial District",
    photos: [
      "https://images.unsplash.com/photo-1512621776951-a57141f2eefd",
      "https://images.unsplash.com/photo-1540420773420-3366772f4999"
    ],
    contactPhoneNumber: "+1-555-0567"
  },
  {
    name: "Cafe de Paris",
    description: "Charming French cafe serving artisanal pastries, croissants, and specialty coffees.",
    openTime: "07:00 AM",
    closeTime: "06:00 PM",
    location: "987 Broadway, Center City",
    photos: [
      "https://images.unsplash.com/photo-1554118811-1e0d58224f24",
      "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb",
      "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085"
    ],
    contactPhoneNumber: "+1-555-0678"
  }
];

const handleInitRestaurants = (req, res) => {
  try {
    const initializeTransaction = db.transaction(() => {
      // Clear existing records in both tables
      db.prepare('DELETE FROM restaurant_photos').run();
      db.prepare('DELETE FROM restaurants').run();

      // Reset auto-increment sequences (optional but clean)
      db.prepare("DELETE FROM sqlite_sequence WHERE name = 'restaurants'").run();
      db.prepare("DELETE FROM sqlite_sequence WHERE name = 'restaurant_photos'").run();

      // Prepare insert statements
      const insertRestaurantStmt = db.prepare(`
        INSERT INTO restaurants (name, description, openTime, closeTime, location, contactPhoneNumber)
        VALUES (?, ?, ?, ?, ?, ?)
      `);

      const insertPhotoStmt = db.prepare(`
        INSERT INTO restaurant_photos (restaurantId, photoUrl)
        VALUES (?, ?)
      `);

      // Insert all mock restaurants and their photos
      for (const restaurant of mockRestaurants) {
        const info = insertRestaurantStmt.run(
          restaurant.name,
          restaurant.description,
          restaurant.openTime,
          restaurant.closeTime,
          restaurant.location,
          restaurant.contactPhoneNumber
        );

        const restaurantId = info.lastInsertRowid;

        for (const photoUrl of restaurant.photos) {
          insertPhotoStmt.run(restaurantId, photoUrl);
        }
      }
    });

    initializeTransaction();

    return res.json({
      success: true,
      message: 'Mock restaurants and photos initialized successfully',
      count: mockRestaurants.length
    });
  } catch (error) {
    console.error('Error initializing restaurants:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
};

// Support both GET and POST for convenience
router.get('/init-restaurants', handleInitRestaurants);
router.post('/init-restaurants', handleInitRestaurants);

module.exports = router;
