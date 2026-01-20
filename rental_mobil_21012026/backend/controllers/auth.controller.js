import { run, get } from "../database/query.js";

export const register = async (req, res) => {
  try {
    const { name, email, password } = req.body;

    if (!email || !password || !name) {
      return res.status(400).json({ message: "Missing required fields" });
    }

    await run(
      `INSERT INTO users (name, email, password)
      VALUES (?, ?, ?)`,
      [name, email, password]
    );
    
    res.json({ success: true, msg: "User registered successfully" });
  } catch (error) {
    if (error.message.includes("UNIQUE")) {
      return res.status(409).json({ msg: "Email already exists" });
    }
    res.status(500).json({ msg: "Internal server error" });
  }
};

export const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await get(
      `SELECT id, name, email, role
      FROM users
      WHERE email = ? AND password = ?`,
      [email, password]
    );
    
    if (!user) {
      return res.status(401).json({ msg: "Invalid email or password" });
    }

    res.json({
      success: true,
      user
    });
  } catch (error) {
    res.status(500).json({ msg: "Internal server error" });
  }
};