// controllers/booking.controller.js
import { run, get } from "../database/query.js";

/**
 * BOOKING MOBIL
 * - Simpan data booking
 * - Update status mobil menjadi "rented"
 * - Kembalikan booking_id (untuk invoice / PDF)
 */
export const booking = async (req, res) => {
    const { email, car_id, days, payment_method } = req.body;

    if (!email || !car_id || !days || !payment_method) {
        return res.status(400).json({ message: "Data booking tidak lengkap" });
    }

    try {
        // 1. Ambil user_id dari email
        const user = await get(
            "SELECT id FROM users WHERE email = ?",
            [email]
        );

        if (!user) {
            return res.status(404).json({ message: "User tidak ditemukan" });
        }

        // 2. Ambil data mobil
        const car = await get(
            "SELECT price_per_day, status FROM cars WHERE id = ?",
            [car_id]
        );

        if (!car) {
            return res.status(404).json({ message: "Mobil tidak ditemukan" });
        }

        if (car.status === "rented") {
            return res.status(400).json({ message: "Mobil sudah dirental" });
        }

        // 3. Hitung tanggal & total
        const startDate = new Date();
        const endDate = new Date();
        endDate.setDate(startDate.getDate() + days);

        const totalPrice = days * car.price_per_day;

        // 2. Simpan booking
        const result = await run(
            "INSERT INTO bookings (user_id, car_id, start_date, end_date, days, total_price, payment_method) VALUES (?,?,?,?,?,?,?)",
            [user.id, car_id, startDate.toISOString(), endDate.toISOString(), days, totalPrice, payment_method]
        );

        // 3. Update status mobil
        await run(
            "UPDATE cars SET status = 'rented' WHERE id = ?",
            [car_id]
        );

        // 4. Response sukses
        res.json({
            success: true,
            message: "Booking berhasil",
            booking_id: result.lastID,
            total_price: totalPrice
        });

    } catch (error) {
        console.error("Booking error:", error);
        res.status(500).json({ message: "Terjadi kesalahan server" });
    }
};


/**
 * AMBIL DATA BOOKING UNTUK PRINT PDF
 */
export const getBookingDetail = async (req, res) => {
    const { id } = req.params;

    try {
        const booking = await get(
            `
            SELECT 
                b.id AS booking_id,
                u.email,
                b.start_date,
                b.end_date,
                b.days,
                b.total_price,
                b.payment_method,
                b.created_at,
                c.brand,
                c.model,
                c.price_per_day
            FROM bookings b
            JOIN users u ON b.user_id = u.id
            JOIN cars c ON b.car_id = c.id
            WHERE b.id = ?
            `,
            [id]
        );

        if (!booking) {
            return res.status(404).json({ message: "Data booking tidak ditemukan" });
        }

        res.json(booking);

    } catch (error) {
        console.error("Get booking detail error:", error);
        res.status(500).json({ message: "Gagal mengambil data booking" });
    }
};
