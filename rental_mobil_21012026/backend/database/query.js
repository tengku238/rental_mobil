import { db } from "./db.js";

// Digunakan untuk INSERT dan UPDATE
export const run = async (sql, params = []) => {
    return db.run(sql, params);
};

// Digunakan untuk SELECT satu data (Profil)
export const get = async (sql, params = []) => {
    return db.get(sql, params);
};

// ... sisa kode tetap sama
export const all = async (sql, params = []) => {
    return db.all(sql, params);
};