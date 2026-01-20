import { all, get, run } from "../database/query.js";

// GET /cars
// ambil daftar mobil
export const getCars = async (req, res) => {
  try {
    const cars = await all(
      `SELECT id, brand, model, rating, transmission,
      description, price_per_day, status, image_url
      FROM cars`
    );
    res.json(cars);
  } catch (error) {
    console.error("Error fetching cars:", error);
    res.status(500).json({ msg: "Gagal mengambil daftar mobil" });
  }
};

// PUT /cars/:id/status
// update status mobil
export const updateCarStatus = async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  if (!["available", "rented"].includes(status)) {
    return res.status(400).json({ msg: "Status mobil tidak valid" });
  }

  try {
    const car = await get("SELECT id FROM cars WHERE id = ?", [id]);
    if (!car) {
      return res.status(404).json({ msg: "Mobil tidak ditemukan" });
    }

    await run(
      "UPDATE cars SET status = ? WHERE id = ?",
      [status, id]
    );

    res.json({
      success: true,
      msg: `Status mobil berhasil diubah menjadi ${status}`
    });
  } catch (error) {
    console.error("Error updating car status:", error);
    res.status(500).json({ msg: "Kesalahan server" });
  }
};  // --- TAMBAHKAN BAGIAN INI ---
// POST /cars
// Tambah mobil baru
export const addCar = async (req, res) => {
  const { brand, model, price_per_day, transmission, rating, image_url, description, status } = req.body;

  // Validasi sederhana
  if (!brand || !model || !price_per_day) {
    return res.status(400).json({ msg: "Data Brand, Model, dan Harga wajib diisi" });
  }

  try {
    await run(
      `INSERT INTO cars (brand, model, price_per_day, transmission, rating, image_url, description, status) 
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        brand, 
        model, 
        price_per_day, 
        transmission || 'Auto', 
        rating || 0, 
        image_url || '', 
        description || '', 
        status || 'available'
      ]
    );

    res.status(201).json({ msg: "Berhasil menambahkan mobil baru" });
  } catch (error) {
    console.error("Error adding car:", error);
    res.status(500).json({ msg: "Gagal menyimpan data ke database" });
  }
};
// --- AKHIRI BAGIAN INI ---