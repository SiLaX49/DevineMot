import express from "express";
import fs from "fs";
import path from "path";
import axios from "axios";
import isOnline from "is-online";
import { fileURLToPath } from "url";
import { DRAWING_CATEGORIES, ALL_CATEGORIES } from "./games.js";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const router = express.Router();
const DATA_DIR = path.join(__dirname, "../data");
const BASE_URL = "https://storage.googleapis.com/quickdraw_dataset/full/simplified";

router.get("/random", async (req, res) => {
  try {
    const online = await isOnline();
    let randomCategory;

    if (online) {
      // 🌐 Mode en ligne : Utiliser une catégorie au hasard parmi toutes
      randomCategory = ALL_CATEGORIES[Math.floor(Math.random() * ALL_CATEGORIES.length)];
      console.log(`🌐 Connexion Internet : Récupération en ligne pour ${randomCategory}.`);

      const url = `${BASE_URL}/${randomCategory}.ndjson`;
      const response = await axios.get(url);
      const lines = response.data.split("\n").filter((line) => line);
      const randomIndex = Math.floor(Math.random() * lines.length);
      const drawing = JSON.parse(lines[randomIndex]);

      res.status(200).json({
        category: randomCategory,
        drawing,
      });
    } else {
      // 📂 Mode hors ligne : Utiliser une catégorie parmi les 5 fichiers locaux
      randomCategory = DRAWING_CATEGORIES[Math.floor(Math.random() * DRAWING_CATEGORIES.length)];
      console.log(`📂 Pas de connexion : Utilisation du fichier local ${randomCategory}.`);

      const localFilePath = path.join(DATA_DIR, `${randomCategory}.ndjson`);
      const fileContent = fs.readFileSync(localFilePath, "utf8").split("\n").filter((line) => line);
      const randomIndex = Math.floor(Math.random() * fileContent.length);
      const drawing = JSON.parse(fileContent[randomIndex]);

      res.status(200).json({
        category: randomCategory,
        drawing,
      });
    }
  } catch (err) {
    console.error("❌ Erreur API Drawing :", err.message);
    res.status(500).json({ error: "Erreur serveur" });
  }
});

export default router;
