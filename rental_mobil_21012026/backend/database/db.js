// database/db.js
import sqlite3 from "sqlite3";
import { open } from "sqlite";

// Fungsi asinkron untuk membuka koneksi dan membuat tabel
async function setupDatabase() {
  const db = await open({
    filename: "./rental.db",
    driver: sqlite3.Database
  });

  console.log("Database connection opened. Ensuring tables exist...");

  // Jalankan semua perintah SQL dalam satu blok exec()
  await db.exec(`
    -- USERS TABLE
      CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL,
      phone TEXT,
      role TEXT DEFAULT 'user',
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );
    

    -- CARS TABLE

    CREATE TABLE IF NOT EXISTS cars (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      brand TEXT NOT NULL,
      model TEXT NOT NULL,
      rating REAL DEFAULT 0,
      transmission TEXT NOT NULL,
      description TEXT,
      price_per_day INTEGER NOT NULL,
      status TEXT DEFAULT 'available',
      image_url TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );


    -- BOOKINGS TABLE

    CREATE TABLE IF NOT EXISTS bookings (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      car_id INTEGER NOT NULL,

      start_date DATE NOT NULL,
      end_date DATE NOT NULL,
      days INTEGER NOT NULL,

      total_price INTEGER NOT NULL,

      payment_method TEXT NOT NULL,
      payment_status TEXT DEFAULT 'unpaid',
      payment_date DATETIME,

      status TEXT DEFAULT 'active',
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

      FOREIGN KEY (user_id) REFERENCES users(id),
      FOREIGN KEY (car_id) REFERENCES cars(id)
    );
  `);

 try {
    await db.run("ALTER TABLE users ADD COLUMN phone TEXT");
    console.log("Kolom 'phone' berhasil ditambahkan.");
  } catch (e) {
    // Abaikan jika kolom sudah ada
    console.log("Kolom 'phone' sudah tersedia.");
  }

  console.log("Database setup complete.");
  return db;
}
// Ekspor koneksi database yang sudah siap digunakan oleh file lain
export const db = await setupDatabase();
