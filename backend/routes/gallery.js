import express from "express";
import Gallery from "../models/Gallery.js";

const router = express.Router();

// Ajouter un dessin à la galerie
router.post("/add", async (req, res) => {
  const { drawingId } = req.body;

  try {
    const existingEntry = await Gallery.findOne({ drawingId });
    if (existingEntry) {
      return res.status(400).json({ message: "Dessin déjà présent dans la galerie." });
    }

    const newEntry = new Gallery({ drawingId });
    await newEntry.save();

    res.status(201).json({ message: "Dessin ajouté à la galerie." });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Voter pour un dessin
router.post("/vote", async (req, res) => {
  const { galleryId } = req.body;

  try {
    const galleryEntry = await Gallery.findById(galleryId);
    if (!galleryEntry) {
      return res.status(404).json({ message: "Dessin non trouvé." });
    }

    galleryEntry.totalVotes++;
    await galleryEntry.save();

    res.status(200).json({ message: "Vote enregistré." });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Obtenir tous les dessins de la galerie
router.get("/", async (req, res) => {
  try {
    const gallery = await Gallery.find().populate("drawingId");
    res.status(200).json(gallery);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
