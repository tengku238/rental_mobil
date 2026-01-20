import express from "express";
import { getCars, updateCarStatus, addCar } from "../controllers/car.controller.js";

const r = express.Router();

r.get("/", getCars);
r.post("/", addCar);
r.put("/:id/status", updateCarStatus);

export default r;
