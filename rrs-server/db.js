const Database = require('better-sqlite3');
const path = require('path');

const dbPath = path.join(__dirname, 'database.sqlite');
const db = new Database(dbPath);

// Schema Migration check 1:
// If restaurants table has the legacy photoUrl column, drop it to rebuild the updated schema.
try {
  const tableInfo = db.prepare("PRAGMA table_info(restaurants)").all();
  const hasPhotoUrl = tableInfo.some(col => col.name === 'photoUrl');
  if (hasPhotoUrl) {
    console.log('Migrating database schema: Dropping legacy restaurants table.');
    db.exec(`
      DROP TABLE IF EXISTS restaurant_photos;
      DROP TABLE IF EXISTS restaurants;
    `);
  }
} catch (error) {
  console.error('Error during migration check:', error);
}

// Schema Migration check 2:
// If reservations table exists but does not have the preOrderList column, alter it.
try {
  // Check if table exists first
  const checkTable = db.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name='reservations'").get();
  if (checkTable) {
    const tableInfo = db.prepare("PRAGMA table_info(reservations)").all();
    const hasPreOrderList = tableInfo.some(col => col.name === 'preOrderList');
    if (!hasPreOrderList) {
      console.log('Migrating database schema: Adding preOrderList column to reservations table.');
      db.exec(`ALTER TABLE reservations ADD COLUMN preOrderList TEXT DEFAULT '{}'`);
    }
  }
} catch (error) {
  console.error('Error during reservations migration check:', error);
}

// Create tables if they do not exist
db.exec(`
  CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    fullname TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  );

  CREATE TABLE IF NOT EXISTS otps (
    email TEXT PRIMARY KEY,
    otp TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  );

  CREATE TABLE IF NOT EXISTS restaurants (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    openTime TEXT,
    closeTime TEXT,
    location TEXT,
    contactPhoneNumber TEXT
  );

  CREATE TABLE IF NOT EXISTS restaurant_photos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    restaurantId INTEGER NOT NULL,
    photoUrl TEXT NOT NULL,
    FOREIGN KEY (restaurantId) REFERENCES restaurants(id) ON DELETE CASCADE
  );

  CREATE TABLE IF NOT EXISTS reservations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    userId INTEGER NOT NULL,
    restaurantId INTEGER NOT NULL,
    time TEXT NOT NULL,
    day TEXT NOT NULL,
    preOrderList TEXT DEFAULT '{}',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (restaurantId) REFERENCES restaurants(id) ON DELETE CASCADE
  );

  CREATE TABLE IF NOT EXISTS menu (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    restaurantId INTEGER NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    category TEXT NOT NULL,
    photoUrl TEXT,
    price REAL NOT NULL,
    FOREIGN KEY (restaurantId) REFERENCES restaurants(id) ON DELETE CASCADE
  );
`);

module.exports = db;
