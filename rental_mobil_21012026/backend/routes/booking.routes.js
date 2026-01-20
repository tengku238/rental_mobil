import express from "express";
import {booking, getBookingDetail} from "../controllers/booking.controller.js";

const r = express.Router();

// POST /booking
r.post("/", booking);

// GET /booking/:id
r.get("/:id", getBookingDetail);

export default r;
