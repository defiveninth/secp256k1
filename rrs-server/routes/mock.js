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
    photoUrl: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4",
    contactPhoneNumber: "+1-555-0199"
  },
  {
    name: "Pizzeria Napoli",
    description: "Authentic wood-fired Neapolitan pizza made with imported Italian ingredients.",
    openTime: "12:00 PM",
    closeTime: "11:00 PM",
    location: "456 Oak Rd, Little Italy",
    photoUrl: "https://images.unsplash.com/photo-1555396273-367ea4eb4db5",
    contactPhoneNumber: "+1-555-0245"
  },
  {
    name: "Sushi Sakura",
    description: "Traditional sushi bar and Japanese dishes served in a minimalist, serene space.",
    openTime: "11:30 AM",
    closeTime: "09:30 PM",
    location: "789 Pine Ave, Uptown",
    photoUrl: "https://images.unsplash.com/photo-1579871494447-9811cf80d66c",
    contactPhoneNumber: "+1-555-0312"
  },
  {
    name: "Taco Loco",
    description: "Vibrant Mexican street food, tacos, and fresh margaritas in a festive atmosphere.",
    openTime: "10:00 AM",
    closeTime: "11:00 PM",
    location: "321 Elm St, West End",
    photoUrl: "https://images.unsplash.com/photo-1565299585323-38d6b0865b47",
    contactPhoneNumber: "+1-555-0456"
  },
  {
    name: "The Green Bowl",
    description: "Healthy salads, grain bowls, smoothies, and plant-based options.",
    openTime: "08:00 AM",
    closeTime: "08:00 PM",
    location: "555 Maple Dr, Financial District",
    photoUrl: "https://images.unsplash.com/photo-1512621776951-a57141f2eefd",
    contactPhoneNumber: "+1-555-0567"
  },
  {
    name: "Cafe de Paris",
    description: "Charming French cafe serving artisanal pastries, croissants, and specialty coffees.",
    openTime: "07:00 AM",
    closeTime: "06:00 PM",
    location: "987 Broadway, Center City",
    photoUrl: "https://images.unsplash.com/photo-1554118811-1e0d58224f24",
    contactPhoneNumber: "+1-555-0678"
  }
];

const handleInitRestaurants = (req, res) => {
  try {
    const initializeTransaction = db.transaction(() => {
      // Clear existing records
      db.prepare('DELETE FROM restaurants').run();

      // Reset auto-increment sequence for sqlite (optional but clean)
      db.prepare("DELETE FROM sqlite_sequence WHERE name = 'restaurants'").run();

      // Prepare insert statement
      const insertStmt = db.prepare(`
        INSERT INTO restaurants (name, description, openTime, closeTime, location, photoUrl, contactPhoneNumber)
        VALUES (?, ?, ?, ?, ?, ?, ?)
      `);

      // Insert all mock restaurants
      for (const restaurant of mockRestaurants) {
        insertStmt.run(
          restaurant.name,
          restaurant.description,
          restaurant.openTime,
          restaurant.closeTime,
          restaurant.location,
          restaurant.photoUrl,
          restaurant.contactPhoneNumber
        );
      }
    });

    initializeTransaction();

    return res.json({
      success: true,
      message: 'Mock restaurants initialized successfully',
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
