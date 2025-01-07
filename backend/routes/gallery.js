import express from "express";
import jwt from "jsonwebtoken";
import Gallery from "../models/Gallery.js";
import User from "../models/User.js";

const router = express.Router();

// Ajouter un dessin ou une image à la galerie
router.post("/add", async (req, res) => {
  const { image } = req.body;
  const token = req.headers.authorization?.split(' ')[1];

  if (!token) {
    return res.status(401).json({ message: "Token manquant" });
  }

  if (!image) {
    return res.status(400).json({ message: "L'image est requise" });
  }

  try {
    // Décoder le token JWT
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const userId = decoded.id;

    // Vérifier que l'utilisateur existe
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: "Utilisateur introuvable" });
    }

    // Enregistrer l'image
    const newEntry = new Gallery({
      image,
      addedBy: userId,
    });
    await newEntry.save();

    res.status(201).json({ message: "Image ajoutée à la galerie avec succès." });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

export default router;
