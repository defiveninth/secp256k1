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
      "/images/img_1.jpg",
      "/images/img_2.jpg",
      "/images/img_3.jpg"
    ],
    contactPhoneNumber: "+1-555-0199",
    menu: [
      {
        name: "Grilled Filet Mignon",
        description: "8oz center-cut tenderloin served with roasted garlic mashed potatoes and red wine reduction.",
        category: "Food",
        price: 42.00,
        photoUrl: "/images/img_4.jpg"
      },
      {
        name: "Pan-Seared Salmon",
        description: "Wild-caught salmon with lemon-herb butter, wild rice, and grilled asparagus.",
        category: "Food",
        price: 34.00,
        photoUrl: "/images/img_5.jpg"
      },
      {
        name: "Truffle Mushroom Risotto",
        description: "Creamy Arborio rice with wild mushrooms, white truffle oil, and shaved parmesan.",
        category: "Food",
        price: 28.00,
        photoUrl: "/images/img_6.jpg"
      },
      {
        name: "Lobster Bisque",
        description: "Rich and creamy lobster soup garnished with fresh lobster meat and chives.",
        category: "Food",
        price: 18.00,
        photoUrl: "/images/img_7.jpg"
      },
      {
        name: "Caesar Salad Deluxe",
        description: "Crisp romaine, house-made croutons, parmesan, and Caesar dressing with grilled chicken.",
        category: "Food",
        price: 16.00,
        photoUrl: "/images/img_8.jpg"
      },
      {
        name: "Cabernet Sauvignon Glass",
        description: "Full-bodied red wine with notes of blackberry, cherry, and subtle oak.",
        category: "Drinks",
        price: 14.00,
        photoUrl: "/images/img_9.jpg"
      },
      {
        name: "Old Fashioned Cocktail",
        description: "Bourbon, Angostura bitters, sugar, and an orange twist.",
        category: "Drinks",
        price: 16.00,
        photoUrl: "/images/img_10.jpg"
      },
      {
        name: "San Pellegrino Sparkling Water",
        description: "Premium Italian sparkling natural mineral water.",
        category: "Drinks",
        price: 6.00,
        photoUrl: "/images/img_11.jpg"
      },
      {
        name: "Chocolate Lava Cake",
        description: "Warm chocolate cake with a molten center, served with vanilla bean ice cream.",
        category: "Desserts",
        price: 12.00,
        photoUrl: "/images/img_12.jpg"
      },
      {
        name: "Classic Creme Brulee",
        description: "Rich custard base topped with a texturally contrasting layer of hardened caramelized sugar.",
        category: "Desserts",
        price: 11.00,
        photoUrl: "/images/img_13.jpg"
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
      "/images/img_14.jpg",
      "/images/img_15.jpg"
    ],
    contactPhoneNumber: "+1-555-0245",
    menu: [
      {
        name: "Margherita Pizza",
        description: "San Marzano tomatoes, fresh mozzarella, fresh basil, and extra virgin olive oil.",
        category: "Pizza",
        price: 14.50,
        photoUrl: "/images/img_16.jpg"
      },
      {
        name: "Pepperoni & Hot Honey Pizza",
        description: "Mozzarella, pepperoni, spicy salami, and a drizzle of hot honey.",
        category: "Pizza",
        price: 16.50,
        photoUrl: "/images/img_17.jpg"
      },
      {
        name: "Prosciutto & Arugula Pizza",
        description: "Fresh mozzarella, prosciutto di Parma, wild arugula, and shaved parmesan.",
        category: "Pizza",
        price: 18.00,
        photoUrl: "/images/img_18.jpg"
      },
      {
        name: "Quattro Formaggi Pizza",
        description: "Mozzarella, gorgonzola, parmesan, and fresh ricotta cheese.",
        category: "Pizza",
        price: 17.00,
        photoUrl: "/images/img_15.jpg"
      },
      {
        name: "Spaghetti Carbonara",
        description: "Egg yolk, pecorino romano, guanciale, and freshly cracked black pepper.",
        category: "Pasta",
        price: 16.00,
        photoUrl: "/images/img_19.jpg"
      },
      {
        name: "Penne Arrabbiata",
        description: "Spicy tomato sauce, garlic, and fresh red chili peppers.",
        category: "Pasta",
        price: 14.00,
        photoUrl: "/images/img_20.jpg"
      },
      {
        name: "Garlic Bread",
        description: "Toasted Italian bread with garlic butter, parsley, and melted mozzarella.",
        category: "Sides",
        price: 6.00,
        photoUrl: "/images/img_21.jpg"
      },
      {
        name: "Italian Soda (Raspberry)",
        description: "Refreshing sparkling soda with sweet raspberry syrup and a splash of cream.",
        category: "Drinks",
        price: 4.50,
        photoUrl: "/images/img_22.jpg"
      },
      {
        name: "Peroni Nastro Azzurro Beer",
        description: "Crisp and refreshing Italian lager beer.",
        category: "Drinks",
        price: 6.50,
        photoUrl: "/images/img_23.jpg"
      },
      {
        name: "Tiramisu Classico",
        description: "Coffee-dipped ladyfingers, mascarpone cream, and cocoa powder.",
        category: "Desserts",
        price: 8.00,
        photoUrl: "/images/img_24.jpg"
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
      "/images/img_25.jpg",
      "/images/img_26.jpg",
      "/images/img_27.jpg"
    ],
    contactPhoneNumber: "+1-555-0312",
    menu: [
      {
        name: "Sakura Roll (Tuna & Avocado)",
        description: "Spicy tuna, cucumber inside, topped with fresh tuna, avocado, and spicy mayo.",
        category: "Sushi Rolls",
        price: 16.00,
        photoUrl: "/images/img_25.jpg"
      },
      {
        name: "Dragon Roll (Eel & Cucumber)",
        description: "Eel and cucumber inside, topped with sliced avocado, eel sauce, and tobiko.",
        category: "Sushi Rolls",
        price: 18.00,
        photoUrl: "/images/img_26.jpg"
      },
      {
        name: "Spicy Tuna Roll",
        description: "Fresh tuna chopped and mixed with house spicy sauce and cucumber.",
        category: "Sushi Rolls",
        price: 12.00,
        photoUrl: "/images/img_27.jpg"
      },
      {
        name: "California Roll",
        description: "Crab salad, avocado, and cucumber wrapped in seaweed and sushi rice.",
        category: "Sushi Rolls",
        price: 10.00,
        photoUrl: "/images/img_28.jpg"
      },
      {
        name: "Salmon Nigiri (2pcs)",
        description: "Slices of fresh raw salmon over small blocks of seasoned sushi rice.",
        category: "Sushi Rolls",
        price: 8.00,
        photoUrl: "/images/img_29.jpg"
      },
      {
        name: "Chicken Teriyaki Bowl",
        description: "Grilled chicken thigh with teriyaki sauce over steamed rice and broccoli.",
        category: "Main Dishes",
        price: 15.50,
        photoUrl: "/images/img_30.jpg"
      },
      {
        name: "Shrimp Tempura (4pcs)",
        description: "Lightly battered and deep-fried fresh shrimp, served with tempura dipping sauce.",
        category: "Main Dishes",
        price: 12.00,
        photoUrl: "/images/img_31.jpg"
      },
      {
        name: "Miso Soup",
        description: "Traditional Japanese soup with dashi broth, tofu, seaweed, and green onions.",
        category: "Sides",
        price: 3.50,
        photoUrl: "/images/img_32.jpg"
      },
      {
        name: "Warm House Sake",
        description: "Traditional fermented rice wine served warm in a ceramic carafe.",
        category: "Drinks",
        price: 9.00,
        photoUrl: "/images/img_33.jpg"
      },
      {
        name: "Matcha Green Tea",
        description: "Authentic hot Japanese green tea whisked to perfection.",
        category: "Drinks",
        price: 3.00,
        photoUrl: "/images/img_34.jpg"
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
      "/images/img_35.jpg",
      "/images/img_36.jpg"
    ],
    contactPhoneNumber: "+1-555-0456",
    menu: [
      {
        name: "Carne Asada Taco",
        description: "Grilled marinated steak, onions, cilantro, and salsa on a fresh corn tortilla.",
        category: "Tacos",
        price: 4.00,
        photoUrl: "/images/img_35.jpg"
      },
      {
        name: "Al Pastor Taco",
        description: "Spit-roasted pork marinated in guajillo chili, with pineapple, onions, and cilantro.",
        category: "Tacos",
        price: 3.75,
        photoUrl: "/images/img_37.jpg"
      },
      {
        name: "Pollo Asado Taco",
        description: "Charbroiled chicken breast, onions, cilantro, and salsa verde.",
        category: "Tacos",
        price: 3.50,
        photoUrl: "/images/img_38.jpg"
      },
      {
        name: "Baja Fish Taco",
        description: "Crispy beer-battered fish, cabbage slaw, pico de gallo, and chipotle crema.",
        category: "Tacos",
        price: 4.50,
        photoUrl: "/images/img_35.jpg"
      },
      {
        name: "Chicken Quesadilla",
        description: "Flour tortilla folded with melted Monterey Jack cheese, grilled chicken, and pico.",
        category: "Food",
        price: 11.00,
        photoUrl: "/images/img_39.jpg"
      },
      {
        name: "Chips & Fresh Guacamole",
        description: "Crispy house tortilla chips served with fresh made-to-order guacamole.",
        category: "Sides",
        price: 8.00,
        photoUrl: "/images/img_40.jpg"
      },
      {
        name: "Elote (Mexican Street Corn)",
        description: "Grilled sweet corn on the cob slathered in mayo, cotija cheese, chili powder, and lime.",
        category: "Sides",
        price: 5.00,
        photoUrl: "/images/img_41.jpg"
      },
      {
        name: "Classic Lime Margarita",
        description: "Tequila, triple sec, fresh lime juice, served on the rocks with a salted rim.",
        category: "Drinks",
        price: 10.00,
        photoUrl: "/images/img_42.jpg"
      },
      {
        name: "Horchata (Large)",
        description: "Traditional sweet, milky rice beverage flavored with cinnamon and vanilla.",
        category: "Drinks",
        price: 4.00,
        photoUrl: "/images/img_43.jpg"
      },
      {
        name: "Jarritos Mandarin Soda",
        description: "Mexican carbonated soda sweetened with natural sugar, mandarin orange flavor.",
        category: "Drinks",
        price: 3.50,
        photoUrl: "/images/img_44.jpg"
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
      "/images/img_45.jpg",
      "/images/img_46.jpg"
    ],
    contactPhoneNumber: "+1-555-0567",
    menu: [
      {
        name: "Harvest Kale Salad",
        description: "Organic kale, roasted sweet potatoes, apples, goat cheese, pumpkin seeds, balsamic vinaigrette.",
        category: "Salads",
        price: 14.00,
        photoUrl: "/images/img_45.jpg"
      },
      {
        name: "Avocado Toast with Egg",
        description: "Artisanal sourdough bread topped with mashed avocado, cherry tomatoes, and a poached egg.",
        category: "Food",
        price: 12.50,
        photoUrl: "/images/img_47.jpg"
      },
      {
        name: "Quinoa Power Bowl",
        description: "Quinoa, organic black beans, corn, avocado, grilled chicken breast, and lime-cilantro dressing.",
        category: "Grain Bowls",
        price: 15.00,
        photoUrl: "/images/img_46.jpg"
      },
      {
        name: "Spicy Tofu Buddha Bowl",
        description: "Brown rice, baked spicy tofu, shredded carrots, edamame, red cabbage, sesame ginger dressing.",
        category: "Grain Bowls",
        price: 14.50,
        photoUrl: "/images/img_30.jpg"
      },
      {
        name: "Hummus & Pita Plate",
        description: "House-made organic chickpea hummus served with warm whole wheat pita bread and cucumbers.",
        category: "Sides",
        price: 9.00,
        photoUrl: "/images/img_48.jpg"
      },
      {
        name: "Green Detox Smoothie",
        description: "Spinach, kale, green apple, banana, ginger, lemon, and coconut water.",
        category: "Smoothies",
        price: 8.50,
        photoUrl: "/images/img_49.jpg"
      },
      {
        name: "Berry Protein Shake",
        description: "Mixed berries, organic vanilla plant protein, almond milk, and honey.",
        category: "Smoothies",
        price: 9.00,
        photoUrl: "/images/img_50.jpg"
      },
      {
        name: "Hibiscus Iced Tea",
        description: "Organic brewed hibiscus flower tea, lightly sweetened with agave syrup.",
        category: "Drinks",
        price: 4.00,
        photoUrl: "/images/img_51.jpg"
      },
      {
        name: "Cold Brew Coffee",
        description: "Slow-steeped smooth dark roast coffee served over ice.",
        category: "Drinks",
        price: 5.00,
        photoUrl: "/images/img_52.jpg"
      },
      {
        name: "Vegan Chocolate Chip Cookie",
        description: "Warm, soft-baked plant-based cookie with dark chocolate chips.",
        category: "Desserts",
        price: 3.50,
        photoUrl: "/images/img_53.jpg"
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
      "/images/img_54.jpg",
      "/images/img_55.jpg",
      "/images/img_56.jpg"
    ],
    contactPhoneNumber: "+1-555-0678",
    menu: [
      {
        name: "Butter Croissant",
        description: "Classic French puff pastry made with layers of rich Normandy butter.",
        category: "Pastries",
        price: 4.00,
        photoUrl: "/images/img_57.jpg"
      },
      {
        name: "Pain au Chocolat",
        description: "Delicious buttery pastry wrapped around dark chocolate bars.",
        category: "Pastries",
        price: 4.50,
        photoUrl: "/images/img_58.jpg"
      },
      {
        name: "Almond Croissant",
        description: "Butter croissant filled with sweet almond frangipane and topped with sliced almonds.",
        category: "Pastries",
        price: 5.00,
        photoUrl: "/images/img_59.jpg"
      },
      {
        name: "Macaron Assortment (6pcs)",
        description: "Six colorful, delicate meringue-based French cookies with sweet cream fillings.",
        category: "Pastries",
        price: 15.00,
        photoUrl: "/images/img_60.jpg"
      },
      {
        name: "Lemon Tart",
        description: "Classic French pastry shell filled with smooth, zesty lemon curd.",
        category: "Pastries",
        price: 6.50,
        photoUrl: "/images/img_61.jpg"
      },
      {
        name: "Croque Monsieur Sandwich",
        description: "Hot baked sandwich featuring French ham, Gruyere cheese, and rich Béchamel sauce.",
        category: "Food",
        price: 12.50,
        photoUrl: "/images/img_62.jpg"
      },
      {
        name: "Cafe Latte",
        description: "Rich espresso combined with steamed milk and topped with a light layer of foam.",
        category: "Coffee",
        price: 4.75,
        photoUrl: "/images/img_63.jpg"
      },
      {
        name: "Cappuccino",
        description: "Double espresso shot topped with equal parts steamed milk and milk foam.",
        category: "Coffee",
        price: 4.75,
        photoUrl: "/images/img_64.jpg"
      },
      {
        name: "Espresso Double",
        description: "Two shots of our rich, signature dark roast espresso blend.",
        category: "Coffee",
        price: 3.50,
        photoUrl: "/images/img_65.jpg"
      },
      {
        name: "Hot Chocolate (French Style)",
        description: "Rich, thick, and velvety melted dark chocolate served warm with fresh whipped cream.",
        category: "Drinks",
        price: 5.50,
        photoUrl: "/images/img_66.jpg"
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
