# RRS Backend Server

A lightweight Express.js server utilizing SQLite for local data persistence. This server powers the Restaurant Reservation System (RRS) app, providing endpoints for authentication, restaurant discovery, menu items, and table reservations with operating hours validation.

## Tech Stack

*   **Runtime**: Node.js
*   **Framework**: Express.js
*   **Database**: SQLite (`better-sqlite3`)
*   **Authentication**: JSON Web Tokens (`jsonwebtoken`)
*   **Security**: Password hashing via `bcryptjs`

---

## Getting Started

### 1. Install Dependencies
Run the following command inside the `rrs-server` directory:
```bash
npm install
```

### 2. Start the Server
Start the development server on port `3000`:
```bash
npm start
```
The server will output: `Server is running on port 3000`.

### 3. Initialize Mock Data
Seed mock restaurants, multiple photos, and full menus (10+ items per restaurant) by sending a request to:
```http
GET http://localhost:3000/mock/init-restaurants
```

---

## Database Architecture

The SQLite database file `database.sqlite` is automatically generated on startup and managed by `db.js`. It contains the following tables:

*   **`users`**: Customer credentials and details.
*   **`otps`**: Temporary validation OTPs mapped to email addresses.
*   **`restaurants`**: Restaurant details, location, and operating hours.
*   **`restaurant_photos`**: 1-to-many relationship mapping multiple Unsplash photos to each restaurant.
*   **`menu`**: 1-to-many mapping of dishes, drinks, and desserts per restaurant (including name, description, category, price, and photoUrl).
*   **`reservations`**: Reservation bookings with strict 30-minute time-slot limits and an optional `preOrderList` JSON blob.

---

## API Endpoints Reference

### 1. Authentication (`/auth`)

#### `POST /auth/check`
Checks if an email is registered.
*   **Request Body**:
    ```json
    { "email": "test@example.com" }
    ```
*   **Response (Exists)**: `{ "exists": true }`
*   **Response (New User)**: Sends an OTP to the email and returns:
    ```json
    {
      "exists": false,
      "message": "OTP sent to email"
    }
    ```

#### `POST /auth/sign-up`
Registers a new user profile using the OTP.
*   **Request Body**:
    ```json
    {
      "email": "test@example.com",
      "otp": "123456",
      "new password": "securepassword",
      "fullname": "Test User"
    }
    ```
*   **Response**: `{ "success": true, "token": "<JWT_TOKEN>", "user": { "id": 1, ... } }`

#### `POST /auth/sign-in`
Authenticates user and returns a session JWT.
*   **Request Body**:
    ```json
    {
      "email": "test@example.com",
      "password": "securepassword"
    }
    ```
*   **Response**: `{ "success": true, "token": "<JWT_TOKEN>", "user": { ... } }`

---

### 2. Restaurants (`/restaurants`)

#### `GET /restaurants`
Returns list of all restaurants with their loaded photos.

#### `GET /restaurants/:id`
Returns a specific restaurant's full details, including its multiple photos and full menu list.

#### `GET /restaurants/:id/menu`
Exposes only the menu items associated with the restaurant.

---

### 3. Reservations (`/reservations`)
*Note: All reservation endpoints require the `Authorization: Bearer <JWT_TOKEN>` header.*

#### `POST /reservations`
Book a reservation.
*   **Validation Constraints**:
    *   Strict 30-minute interval slots (e.g. `10:00`, `10:30`, `11:00`).
    *   Time slot must fall within operating hours. Restaurants with both open/close times set to `00:00` are treated as 24/7.
*   **Request Body**:
    ```json
    {
      "restaurantId": 1,
      "time": "12:30",
      "day": "2026-07-01",
      "preOrderList": { "1": 2, "3": 1 } 
    }
    ```
*   **Response**: `{ "success": true, "reservation": { ... } }`

#### `GET /reservations`
Returns all reservations for the currently authenticated user.

#### `GET /reservations/:id`
Returns details for a specific reservation owned by the user.

#### `PUT /reservations/:id`
Updates reservation details (validating against time slot and operating hour limits).

#### `DELETE /reservations/:id`
Cancels the reservation.
