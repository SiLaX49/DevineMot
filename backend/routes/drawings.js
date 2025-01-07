import express from "express";
import axios from "axios";
import { DRAWING_CATEGORIES, ALL_CATEGORIES, CATEGORIES } from "./games.js";
import { BASE_URL } from "./games.js";

const router = express.Router();


router.get("/random", async (req, res) => {
  try {
    // 🛠️ Choisir une catégorie aléatoire
    const randomCategory = ALL_CATEGORIES[Math.floor(Math.random() * ALL_CATEGORIES.length)];
    console.log(`🛠️ Catégorie sélectionnée : ${randomCategory}`);

    // 🛠️ Vérification de BASE_URL
    console.log(`🌐 BASE_URL actuel : ${BASE_URL}`);
    const url = `${BASE_URL}/${randomCategory}.ndjson`;
    console.log(`🌐 URL finale : ${url}`);

    // 🌐 Tentative d'accès aux données en ligne
    const response = await axios.get(url, { responseType: "stream" });

    const readline = require("readline");
    const rl = readline.createInterface({
      input: response.data,
      crlfDelay: Infinity,
    });

    let selectedLine = null;
    let lineCount = 0;
    for await (const line of rl) {
      lineCount++;
      if (Math.random() < 1 / lineCount) {
        selectedLine = line;
      }
    }

    if (!selectedLine) {
      throw new Error("Aucun dessin n'a été sélectionné.");
    }

    const drawingData = JSON.parse(selectedLine);

    console.log(`✅ Dessin récupéré avec succès depuis : ${url}`);

    return res.status(200).json({
      category: randomCategory,
      drawing: drawingData.drawing,
      word: CATEGORIES[randomCategory] || randomCategory,
    });
  } catch (error) {
    console.error(`❌ Erreur API Drawing : ${error.message}`);

    // 📂 Bascule vers les catégories locales
    try {
      const randomCategory = DRAWING_CATEGORIES[Math.floor(Math.random() * DRAWING_CATEGORIES.length)];
      const localFilePath = `./data/${randomCategory}.ndjson`;
      console.log(`📂 Bascule en mode hors-ligne avec le fichier : ${localFilePath}`);

      const fs = require("fs");
      const fileContent = fs.readFileSync(localFilePath, "utf8").split("\n").filter((line) => line);
      const randomIndex = Math.floor(Math.random() * fileContent.length);
      const drawingData = JSON.parse(fileContent[randomIndex]);

      console.log(`✅ Récupération réussie depuis le fichier local : ${randomCategory}`);

      return res.status(200).json({
        category: randomCategory,
        drawing: drawingData.drawing,
        word: CATEGORIES[randomCategory] || randomCategory,
      });
    } catch (localError) {
      console.error(`❌ Échec en mode hors-ligne : ${localError.message}`);
      return res.status(500).json({ error: "Échec complet en ligne et hors-ligne." });
    }
  }
});

export default router;
