import express from "express";
import verifyToken from "../utils/verifyToken.js";
import { checkRole } from "../middleware/roleMiddleware.js";

const router = express.Router();

// Route Admin Dashboard
router.get("/dashboard", verifyToken, checkRole('admin'), (req, res) => {
  res.status(200).json({ message: "Bienvenue dans le Tableau de Bord Admin !" });
});

// Route pour voir les utilisateurs (exemple)
router.get("/users", verifyToken, checkRole('admin'), (req, res) => {
  res.status(200).json({ message: "Liste des utilisateurs (exemple)." });
});

export default router;
