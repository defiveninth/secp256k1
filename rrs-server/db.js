const Database = require('better-sqlite3');
const path = require('path');

const dbPath = path.join(__dirname, 'database.sqlite');
const db = new Database(dbPath);

// Schema Migration check:
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
`);

module.exports = db;
