import express from "express";
import fs from "fs";
import path from "path";
import axios from "axios";
import isOnline from "is-online";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const router = express.Router();
const DATA_DIR = path.join(__dirname, "../data");
const BASE_URL = "https://storage.googleapis.com/quickdraw_dataset/full/simplified";

router.get("/random", async (req, res) => {
  const category = "cat"; // Catégorie par défaut
  const localFilePath = path.join(DATA_DIR, `${category}.ndjson`);

  try {
    const online = await isOnline();

    if (online) {
      console.log("Connexion Internet détectée : récupération en ligne.");
      const url = `${BASE_URL}/${category}.ndjson`;
      const response = await axios.get(url);

      const lines = response.data.split("\n").filter((line) => line);
      const randomIndex = Math.floor(Math.random() * lines.length);
      const drawing = JSON.parse(lines[randomIndex]);

      res.status(200).json(drawing);
    } else {
      console.log("Pas de connexion Internet : utilisation des fichiers locaux.");
      const fileContent = fs.readFileSync(localFilePath, "utf8").split("\n");
      const randomIndex = Math.floor(Math.random() * (fileContent.length - 1));
      const drawing = JSON.parse(fileContent[randomIndex]);

      res.status(200).json(drawing);
    }
  } catch (err) {
    console.error("❌ Erreur API Drawing :", err.message);
    res.status(500).json({ error: "Erreur serveur" });
  }
});

export default router;
