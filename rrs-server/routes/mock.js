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
    contactPhoneNumber: "+1-555-0199",
    menu: [
      {
        name: "Grilled Filet Mignon",
        description: "8oz center-cut tenderloin served with roasted garlic mashed potatoes and red wine reduction.",
        category: "Food",
        price: 42.00,
        photoUrl: "https://images.unsplash.com/photo-1544025162-d76694265947"
      },
      {
        name: "Pan-Seared Salmon",
        description: "Wild-caught salmon with lemon-herb butter, wild rice, and grilled asparagus.",
        category: "Food",
        price: 34.00,
        photoUrl: "https://images.unsplash.com/photo-1467003909585-2f8a72700288"
      },
      {
        name: "Truffle Mushroom Risotto",
        description: "Creamy Arborio rice with wild mushrooms, white truffle oil, and shaved parmesan.",
        category: "Food",
        price: 28.00,
        photoUrl: "https://images.unsplash.com/photo-1476124369491-e7addf5db371"
      },
      {
        name: "Lobster Bisque",
        description: "Rich and creamy lobster soup garnished with fresh lobster meat and chives.",
        category: "Food",
        price: 18.00,
        photoUrl: "https://images.unsplash.com/photo-1594756202469-9ff9799b2e4e"
      },
      {
        name: "Caesar Salad Deluxe",
        description: "Crisp romaine, house-made croutons, parmesan, and Caesar dressing with grilled chicken.",
        category: "Food",
        price: 16.00,
        photoUrl: "https://images.unsplash.com/photo-1550304943-4f24f54ddde9"
      },
      {
        name: "Cabernet Sauvignon Glass",
        description: "Full-bodied red wine with notes of blackberry, cherry, and subtle oak.",
        category: "Drinks",
        price: 14.00,
        photoUrl: "https://images.unsplash.com/photo-1506377247377-2a5b3b417ebb"
      },
      {
        name: "Old Fashioned Cocktail",
        description: "Bourbon, Angostura bitters, sugar, and an orange twist.",
        category: "Drinks",
        price: 16.00,
        photoUrl: "https://images.unsplash.com/photo-1470337458703-46ad1756a187"
      },
      {
        name: "San Pellegrino Sparkling Water",
        description: "Premium Italian sparkling natural mineral water.",
        category: "Drinks",
        price: 6.00,
        photoUrl: "https://images.unsplash.com/photo-1523362628745-0c100150b504"
      },
      {
        name: "Chocolate Lava Cake",
        description: "Warm chocolate cake with a molten center, served with vanilla bean ice cream.",
        category: "Desserts",
        price: 12.00,
        photoUrl: "https://images.unsplash.com/photo-1606313564200-e75d5e30476c"
      },
      {
        name: "Classic Creme Brulee",
        description: "Rich custard base topped with a texturally contrasting layer of hardened caramelized sugar.",
        category: "Desserts",
        price: 11.00,
        photoUrl: "https://images.unsplash.com/photo-1470324161839-ce2bb6fa6bc3"
      }
    ]
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
    contactPhoneNumber: "+1-555-0245",
    menu: [
      {
        name: "Margherita Pizza",
        description: "San Marzano tomatoes, fresh mozzarella, fresh basil, and extra virgin olive oil.",
        category: "Pizza",
        price: 14.50,
        photoUrl: "https://images.unsplash.com/photo-1574071318508-1cdbab80d002"
      },
      {
        name: "Pepperoni & Hot Honey Pizza",
        description: "Mozzarella, pepperoni, spicy salami, and a drizzle of hot honey.",
        category: "Pizza",
        price: 16.50,
        photoUrl: "https://images.unsplash.com/photo-1628840042765-356cda07504e"
      },
      {
        name: "Prosciutto & Arugula Pizza",
        description: "Fresh mozzarella, prosciutto di Parma, wild arugula, and shaved parmesan.",
        category: "Pizza",
        price: 18.00,
        photoUrl: "https://images.unsplash.com/photo-1534308983496-4fabb1a015ee"
      },
      {
        name: "Quattro Formaggi Pizza",
        description: "Mozzarella, gorgonzola, parmesan, and fresh ricotta cheese.",
        category: "Pizza",
        price: 17.00,
        photoUrl: "https://images.unsplash.com/photo-1513104890138-7c749659a591"
      },
      {
        name: "Spaghetti Carbonara",
        description: "Egg yolk, pecorino romano, guanciale, and freshly cracked black pepper.",
        category: "Pasta",
        price: 16.00,
        photoUrl: "https://images.unsplash.com/photo-1612874742237-6526221588e3"
      },
      {
        name: "Penne Arrabbiata",
        description: "Spicy tomato sauce, garlic, and fresh red chili peppers.",
        category: "Pasta",
        price: 14.00,
        photoUrl: "https://images.unsplash.com/photo-1546549032-9571cd6b27df"
      },
      {
        name: "Garlic Bread",
        description: "Toasted Italian bread with garlic butter, parsley, and melted mozzarella.",
        category: "Sides",
        price: 6.00,
        photoUrl: "https://images.unsplash.com/photo-1619535860434-ba1d8fa12536"
      },
      {
        name: "Italian Soda (Raspberry)",
        description: "Refreshing sparkling soda with sweet raspberry syrup and a splash of cream.",
        category: "Drinks",
        price: 4.50,
        photoUrl: "https://images.unsplash.com/photo-1551024709-8f23befc6f87"
      },
      {
        name: "Peroni Nastro Azzurro Beer",
        description: "Crisp and refreshing Italian lager beer.",
        category: "Drinks",
        price: 6.50,
        photoUrl: "https://images.unsplash.com/photo-1600788886242-5c96aabe3757"
      },
      {
        name: "Tiramisu Classico",
        description: "Coffee-dipped ladyfingers, mascarpone cream, and cocoa powder.",
        category: "Desserts",
        price: 8.00,
        photoUrl: "https://images.unsplash.com/photo-1571877227200-a0d98ea607e9"
      }
    ]
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
    contactPhoneNumber: "+1-555-0312",
    menu: [
      {
        name: "Sakura Roll (Tuna & Avocado)",
        description: "Spicy tuna, cucumber inside, topped with fresh tuna, avocado, and spicy mayo.",
        category: "Sushi Rolls",
        price: 16.00,
        photoUrl: "https://images.unsplash.com/photo-1579871494447-9811cf80d66c"
      },
      {
        name: "Dragon Roll (Eel & Cucumber)",
        description: "Eel and cucumber inside, topped with sliced avocado, eel sauce, and tobiko.",
        category: "Sushi Rolls",
        price: 18.00,
        photoUrl: "https://images.unsplash.com/photo-1611143669185-af224c5e3252"
      },
      {
        name: "Spicy Tuna Roll",
        description: "Fresh tuna chopped and mixed with house spicy sauce and cucumber.",
        category: "Sushi Rolls",
        price: 12.00,
        photoUrl: "https://images.unsplash.com/photo-1553621042-f6e147245754"
      },
      {
        name: "California Roll",
        description: "Crab salad, avocado, and cucumber wrapped in seaweed and sushi rice.",
        category: "Sushi Rolls",
        price: 10.00,
        photoUrl: "https://images.unsplash.com/photo-1583623025817-d180a2221d0a"
      },
      {
        name: "Salmon Nigiri (2pcs)",
        description: "Slices of fresh raw salmon over small blocks of seasoned sushi rice.",
        category: "Sushi Rolls",
        price: 8.00,
        photoUrl: "https://images.unsplash.com/photo-1617196034796-73dfa7b1fd56"
      },
      {
        name: "Chicken Teriyaki Bowl",
        description: "Grilled chicken thigh with teriyaki sauce over steamed rice and broccoli.",
        category: "Main Dishes",
        price: 15.50,
        photoUrl: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c"
      },
      {
        name: "Shrimp Tempura (4pcs)",
        description: "Lightly battered and deep-fried fresh shrimp, served with tempura dipping sauce.",
        category: "Main Dishes",
        price: 12.00,
        photoUrl: "https://images.unsplash.com/photo-1626074353765-517a681e40be"
      },
      {
        name: "Miso Soup",
        description: "Traditional Japanese soup with dashi broth, tofu, seaweed, and green onions.",
        category: "Sides",
        price: 3.50,
        photoUrl: "https://images.unsplash.com/photo-1607330289024-1535c6b4e1c1"
      },
      {
        name: "Warm House Sake",
        description: "Traditional fermented rice wine served warm in a ceramic carafe.",
        category: "Drinks",
        price: 9.00,
        photoUrl: "https://images.unsplash.com/photo-1609951651556-5334e2706168"
      },
      {
        name: "Matcha Green Tea",
        description: "Authentic hot Japanese green tea whisked to perfection.",
        category: "Drinks",
        price: 3.00,
        photoUrl: "https://images.unsplash.com/photo-1536256263959-770b48d82b0a"
      }
    ]
  },
  {
    name: "Taco Loco",
    description: "Vibrant Mexican street food, tacos, and fresh margaritas in a festive atmosphere.",
    openTime: "10:00 AM",
    closeTime: "11:00 PM",
    location: "321 Elm St, West End",
    photos: [
      "https://images.unsplash.com/photo-1565299585323-38d6b0865b47",
      "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38"
    ],
    contactPhoneNumber: "+1-555-0456",
    menu: [
      {
        name: "Carne Asada Taco",
        description: "Grilled marinated steak, onions, cilantro, and salsa on a fresh corn tortilla.",
        category: "Tacos",
        price: 4.00,
        photoUrl: "https://images.unsplash.com/photo-1565299585323-38d6b0865b47"
      },
      {
        name: "Al Pastor Taco",
        description: "Spit-roasted pork marinated in guajillo chili, with pineapple, onions, and cilantro.",
        category: "Tacos",
        price: 3.75,
        photoUrl: "https://images.unsplash.com/photo-1551504734-5ee1c4a1479b"
      },
      {
        name: "Pollo Asado Taco",
        description: "Charbroiled chicken breast, onions, cilantro, and salsa verde.",
        category: "Tacos",
        price: 3.50,
        photoUrl: "https://images.unsplash.com/photo-1615870216519-2f9fa575fa5c"
      },
      {
        name: "Baja Fish Taco",
        description: "Crispy beer-battered fish, cabbage slaw, pico de gallo, and chipotle crema.",
        category: "Tacos",
        price: 4.50,
        photoUrl: "https://images.unsplash.com/photo-1565299585323-38d6b0865b47"
      },
      {
        name: "Chicken Quesadilla",
        description: "Flour tortilla folded with melted Monterey Jack cheese, grilled chicken, and pico.",
        category: "Food",
        price: 11.00,
        photoUrl: "https://images.unsplash.com/photo-1618040996337-56904b7850b9"
      },
      {
        name: "Chips & Fresh Guacamole",
        description: "Crispy house tortilla chips served with fresh made-to-order guacamole.",
        category: "Sides",
        price: 8.00,
        photoUrl: "https://images.unsplash.com/photo-1513456852971-30c0b8199d4d"
      },
      {
        name: "Elote (Mexican Street Corn)",
        description: "Grilled sweet corn on the cob slathered in mayo, cotija cheese, chili powder, and lime.",
        category: "Sides",
        price: 5.00,
        photoUrl: "https://images.unsplash.com/photo-1551782450-17144efb9c50"
      },
      {
        name: "Classic Lime Margarita",
        description: "Tequila, triple sec, fresh lime juice, served on the rocks with a salted rim.",
        category: "Drinks",
        price: 10.00,
        photoUrl: "https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b"
      },
      {
        name: "Horchata (Large)",
        description: "Traditional sweet, milky rice beverage flavored with cinnamon and vanilla.",
        category: "Drinks",
        price: 4.00,
        photoUrl: "https://images.unsplash.com/photo-1541658016709-82535e94bc69"
      },
      {
        name: "Jarritos Mandarin Soda",
        description: "Mexican carbonated soda sweetened with natural sugar, mandarin orange flavor.",
        category: "Drinks",
        price: 3.50,
        photoUrl: "https://images.unsplash.com/photo-1622483767028-3f66f32aef97"
      }
    ]
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
    contactPhoneNumber: "+1-555-0567",
    menu: [
      {
        name: "Harvest Kale Salad",
        description: "Organic kale, roasted sweet potatoes, apples, goat cheese, pumpkin seeds, balsamic vinaigrette.",
        category: "Salads",
        price: 14.00,
        photoUrl: "https://images.unsplash.com/photo-1512621776951-a57141f2eefd"
      },
      {
        name: "Avocado Toast with Egg",
        description: "Artisanal sourdough bread topped with mashed avocado, cherry tomatoes, and a poached egg.",
        category: "Food",
        price: 12.50,
        photoUrl: "https://images.unsplash.com/photo-1525351484163-7529414344d8"
      },
      {
        name: "Quinoa Power Bowl",
        description: "Quinoa, organic black beans, corn, avocado, grilled chicken breast, and lime-cilantro dressing.",
        category: "Grain Bowls",
        price: 15.00,
        photoUrl: "https://images.unsplash.com/photo-1540420773420-3366772f4999"
      },
      {
        name: "Spicy Tofu Buddha Bowl",
        description: "Brown rice, baked spicy tofu, shredded carrots, edamame, red cabbage, sesame ginger dressing.",
        category: "Grain Bowls",
        price: 14.50,
        photoUrl: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c"
      },
      {
        name: "Hummus & Pita Plate",
        description: "House-made organic chickpea hummus served with warm whole wheat pita bread and cucumbers.",
        category: "Sides",
        price: 9.00,
        photoUrl: "https://images.unsplash.com/photo-1547058881-aa0edd92aab3"
      },
      {
        name: "Green Detox Smoothie",
        description: "Spinach, kale, green apple, banana, ginger, lemon, and coconut water.",
        category: "Smoothies",
        price: 8.50,
        photoUrl: "https://images.unsplash.com/photo-1553530666-ba11a7da3888"
      },
      {
        name: "Berry Protein Shake",
        description: "Mixed berries, organic vanilla plant protein, almond milk, and honey.",
        category: "Smoothies",
        price: 9.00,
        photoUrl: "https://images.unsplash.com/photo-1553530979-7ee52a2670c4"
      },
      {
        name: "Hibiscus Iced Tea",
        description: "Organic brewed hibiscus flower tea, lightly sweetened with agave syrup.",
        category: "Drinks",
        price: 4.00,
        photoUrl: "https://images.unsplash.com/photo-1497534446932-c925b458314e"
      },
      {
        name: "Cold Brew Coffee",
        description: "Slow-steeped smooth dark roast coffee served over ice.",
        category: "Drinks",
        price: 5.00,
        photoUrl: "https://images.unsplash.com/photo-1517701604599-bb29b565090c"
      },
      {
        name: "Vegan Chocolate Chip Cookie",
        description: "Warm, soft-baked plant-based cookie with dark chocolate chips.",
        category: "Desserts",
        price: 3.50,
        photoUrl: "https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e"
      }
    ]
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
    contactPhoneNumber: "+1-555-0678",
    menu: [
      {
        name: "Butter Croissant",
        description: "Classic French puff pastry made with layers of rich Normandy butter.",
        category: "Pastries",
        price: 4.00,
        photoUrl: "https://images.unsplash.com/photo-1555507036-ab1f4038808a"
      },
      {
        name: "Pain au Chocolat",
        description: "Delicious buttery pastry wrapped around dark chocolate bars.",
        category: "Pastries",
        price: 4.50,
        photoUrl: "https://images.unsplash.com/photo-1608686207856-001b95cf60ca"
      },
      {
        name: "Almond Croissant",
        description: "Butter croissant filled with sweet almond frangipane and topped with sliced almonds.",
        category: "Pastries",
        price: 5.00,
        photoUrl: "https://images.unsplash.com/photo-1509440159596-0249088772ff"
      },
      {
        name: "Macaron Assortment (6pcs)",
        description: "Six colorful, delicate meringue-based French cookies with sweet cream fillings.",
        category: "Pastries",
        price: 15.00,
        photoUrl: "https://images.unsplash.com/photo-1569864358642-9d1684040f43"
      },
      {
        name: "Lemon Tart",
        description: "Classic French pastry shell filled with smooth, zesty lemon curd.",
        category: "Pastries",
        price: 6.50,
        photoUrl: "https://images.unsplash.com/photo-1519869325930-281384150729"
      },
      {
        name: "Croque Monsieur Sandwich",
        description: "Hot baked sandwich featuring French ham, Gruyere cheese, and rich Béchamel sauce.",
        category: "Food",
        price: 12.50,
        photoUrl: "https://images.unsplash.com/photo-1482049016688-2d3e1b311543"
      },
      {
        name: "Cafe Latte",
        description: "Rich espresso combined with steamed milk and topped with a light layer of foam.",
        category: "Coffee",
        price: 4.75,
        photoUrl: "https://images.unsplash.com/photo-1541167760496-1628856ab772"
      },
      {
        name: "Cappuccino",
        description: "Double espresso shot topped with equal parts steamed milk and milk foam.",
        category: "Coffee",
        price: 4.75,
        photoUrl: "https://images.unsplash.com/photo-1509042239860-f550ce710b93"
      },
      {
        name: "Espresso Double",
        description: "Two shots of our rich, signature dark roast espresso blend.",
        category: "Coffee",
        price: 3.50,
        photoUrl: "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd"
      },
      {
        name: "Hot Chocolate (French Style)",
        description: "Rich, thick, and velvety melted dark chocolate served warm with fresh whipped cream.",
        category: "Drinks",
        price: 5.50,
        photoUrl: "https://images.unsplash.com/photo-1544787219-7f47ccb76574"
      }
    ]
  }
];

const handleInitRestaurants = (req, res) => {
  try {
    const initializeTransaction = db.transaction(() => {
      // Clear existing records in all tables
      db.prepare('DELETE FROM menu').run();
      db.prepare('DELETE FROM restaurant_photos').run();
      db.prepare('DELETE FROM restaurants').run();

      // Reset auto-increment sequences (optional but clean)
      db.prepare("DELETE FROM sqlite_sequence WHERE name = 'restaurants'").run();
      db.prepare("DELETE FROM sqlite_sequence WHERE name = 'restaurant_photos'").run();
      db.prepare("DELETE FROM sqlite_sequence WHERE name = 'menu'").run();

      // Prepare insert statements
      const insertRestaurantStmt = db.prepare(`
        INSERT INTO restaurants (name, description, openTime, closeTime, location, contactPhoneNumber)
        VALUES (?, ?, ?, ?, ?, ?)
      `);

      const insertPhotoStmt = db.prepare(`
        INSERT INTO restaurant_photos (restaurantId, photoUrl)
        VALUES (?, ?)
      `);

      const insertMenuStmt = db.prepare(`
        INSERT INTO menu (restaurantId, name, description, category, photoUrl, price)
        VALUES (?, ?, ?, ?, ?, ?)
      `);

      // Insert all mock restaurants, their photos, and menus
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

        // Insert photos
        for (const photoUrl of restaurant.photos) {
          insertPhotoStmt.run(restaurantId, photoUrl);
        }

        // Insert menu items
        for (const menuItem of restaurant.menu) {
          insertMenuStmt.run(
            restaurantId,
            menuItem.name,
            menuItem.description,
            menuItem.category,
            menuItem.photoUrl,
            menuItem.price
          );
        }
      }
    });

    initializeTransaction();

    return res.json({
      success: true,
      message: 'Mock restaurants, photos, and menus initialized successfully',
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
