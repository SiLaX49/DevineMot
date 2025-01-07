import express from "express";
import Game from "../models/Game.js";
import verifyToken from "../utils/verifyToken.js";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const router = express.Router();

// 🛠️ Crée une variable équivalente à __dirname
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// ⚙️ Dossier des fichiers NDJSON
const DATA_DIR = path.join(__dirname, "../data");
export const BASE_URL = "https://storage.googleapis.com/quickdraw_dataset/full/simplified";

// Toutes les catégories disponibles télécharger
export const DRAWING_CATEGORIES = [
  "apple", "banana", "bed", "book", "car", "cat", "dog", "fish",
    "flower", "house", "moon", "sun", "tree", "star", "bird", "hat", "key",
    "shoe", "train", "clock", "cloud", "hand", "face", "ear", "eye",
    "chair", "table", "cup", "door", "hat", "leaf", "pants",
    "bread", "cake", "bus",
    "pencil", "fork", "spoon", "pizza"
];

// 🛠️ Liste simplifiée de catégories pour les utilisateurs
export const ALL_CATEGORIES = [
  "apple", "banana", "bed", "book", "car", "cat", "dog", "fish",
  "flower", "house", "moon", "sun", "tree", "star", "bird", "hat", "key",
  "shoe", "train", "clock", "cloud", "hand", "face", "ear", "eye",
  "chair", "table", "cup", "door", "hat", "leaf", "pants",
  "bread", "cake", "bus",
  "pencil", "fork", "spoon", "pizza"
];

// 🛠️ Traductions simplifiées des catégories pour affichage côté utilisateur
export const CATEGORIES = {
  "apple": "pomme",
  "banana": "banane",
  "ball": "balle",
  "bed": "lit",
  "book": "livre",
  "car": "voiture",
  "cat": "chat",
  "dog": "chien",
  "fish": "poisson",
  "flower": "fleur",
  "house": "maison",
  "moon": "lune",
  "sun": "soleil",
  "tree": "arbre",
  "star": "étoile",
  "bird": "oiseau",
  "hat": "chapeau",
  "key": "clé",
  "shoe": "chaussure",
  "train": "train",
  "clock": "horloge",
  "cloud": "nuage",
  "heart": "cœur",
  "hand": "main",
  "face": "visage",
  "ear": "oreille",
  "eye": "œil",
  "chair": "chaise",
  "table": "table",
  "cup": "tasse",
  "door": "porte",
  "window": "fenêtre",
  "leaf": "feuille",
  "shirt": "chemise",
  "pants": "pantalon",
  "bread": "pain",
  "cake": "gâteau",
  "milk": "lait",
  "water": "eau",
  "boat": "bateau",
  "bus": "bus",
  "plane": "avion",
  "phone": "téléphone",
  "pen": "stylo",
  "pencil": "crayon",
  "bag": "sac",
  "fork": "fourchette",
  "spoon": "cuillère",
  "pizza": "pizza"
}

router.get("/game/random", async (req, res) => {
  try {
    // 🌐 Étape 1 : Choisir une catégorie aléatoire depuis toutes les catégories
    let randomCategory = ALL_CATEGORIES[Math.floor(Math.random() * ALL_CATEGORIES.length)];
    console.log(`🌐 Tentative de récupération en ligne (RAW) pour la catégorie : ${randomCategory}`);

    try {
      // ✅ Tentative d'accès aux données RAW en ligne
      const url = `${BASE_URL}/${randomCategory}.ndjson`;
      const response = await axios.get(url);
      const lines = response.data.split("\n").filter((line) => line);
      const randomIndex = Math.floor(Math.random() * lines.length);
      const drawingData = JSON.parse(lines[randomIndex]);

      console.log(`✅ Récupération réussie depuis Internet (RAW) pour la catégorie : ${randomCategory}`);

      return res.status(200).json({
        category: randomCategory,
        drawing: drawingData.drawing,
        word: CATEGORIES[randomCategory] || randomCategory,
      });
    } catch (error) {
      console.warn(`⚠️ Échec de la récupération en ligne pour ${randomCategory}. Erreur : ${error.message}`);
      console.warn(`📂 Bascule en mode hors-ligne avec les catégories locales.`);

      // 📂 Étape 2 : Fallback vers les catégories locales
      randomCategory = DRAWING_CATEGORIES[Math.floor(Math.random() * DRAWING_CATEGORIES.length)];
      const localFilePath = path.join(DATA_DIR, `${randomCategory}.ndjson`);

      if (!fs.existsSync(localFilePath)) {
        console.error(`❌ Fichier NDJSON local manquant pour : ${randomCategory}`);
        return res.status(500).json({ error: "Fichier local introuvable et récupération en ligne échouée." });
      }

      const fileContent = fs.readFileSync(localFilePath, "utf8").split("\n").filter((line) => line);
      const randomIndex = Math.floor(Math.random() * fileContent.length);
      const drawingData = JSON.parse(fileContent[randomIndex]);

      console.log(`✅ Récupération réussie depuis le fichier local : ${randomCategory}`);

      return res.status(200).json({
        category: randomCategory,
        drawing: drawingData.drawing,
        word: CATEGORIES[randomCategory] || randomCategory,
      });
    }
  } catch (err) {
    console.error(`❌ Erreur API Drawing : ${err.message}`);
    res.status(500).json({ error: "Erreur serveur" });
  }
});

export default router;