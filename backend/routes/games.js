import express from "express";
import Game from "../models/Game.js";
import verifyToken from "../utils/verifyToken.js";

const router = express.Router();

// Enregistrer une partie
router.post("/save", verifyToken, async (req, res) => {
  const { drawingId, userAnswer, isCorrect, score } = req.body;
  try {
    const newGame = new Game({
      userId: req.user.id,
      drawingId,
      userAnswer,
      isCorrect,
      score,
    });
    await newGame.save();
    res.status(201).json({ message: "Game saved successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Obtenir l'historique des parties d'un utilisateur
router.get("/history", verifyToken, async (req, res) => {
  try {
    const games = await Game.find({ userId: req.user.id }).populate("drawingId");
    res.status(200).json(games);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
