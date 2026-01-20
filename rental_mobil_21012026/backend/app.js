import express from "express";
import cors from "cors";
import auth from "./routes/auth.routes.js";
import car from "./routes/car.routes.js";
import booking from "./routes/booking.routes.js";

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use("/auth", auth);
app.use("/cars", car);
app.use("/booking", booking);

// --- PENCEGAHAN AGAR SERVER TIDAK MATI ---

// Handler untuk error yang tidak tertangkap (mencegah crash)
process.on('uncaughtException', (err) => {
    console.error('CRITICAL ERROR (Uncaught):', err.message, err.stack);
});

process.on('unhandledRejection', (reason, promise) => {
    console.error('UNHANDLED REJECTION:', reason);
});

// Middleware penangkap error terakhir
app.use((err, req, res, next) => {
    console.error("Internal Server Error:", err.stack);
    res.status(500).json({ message: "Terjadi kesalahan pada server" });
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Backend running http://localhost:${PORT}`);
});
