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

// 🛠️ 5 Catégories pour le mode hors-ligne
export const DRAWING_CATEGORIES = [
  "aircraft carrier", "airplane", "alarm clock", "ambulance", "angel",
    "animal migration", "ant", "anvil", "apple", "arm", "asparagus", "axe",
    "backpack", "banana", "bandage", "barn", "baseball", "basket",
    "basketball", "bat", "bathtub", "beach", "bear", "beard", "bed", "bee",
    "belt", "bench", "bicycle", "binoculars", "bird", "birthday cake",
    "blackberry", "blueberry", "book", "boomerang", "bottlecap", "bowtie",
    "bracelet", "brain", "bread", "bridge", "broccoli", "broom", "bucket",
    "bulldozer", "bus", "bush", "butterfly", "cactus", "cake", "calculator",
    "calendar", "camel", "camera", "campfire", "candle", "cannon", "canoe",
    "car", "carrot", "castle", "cat", "ceiling fan", "cello", "cell phone",
    "chair", "chandelier", "clock", "cloud",
    "coffee cup", "compass", "computer", "cookie", "cooler", "couch", "cow",
    "crab", "crayon", "crocodile", "crown", "cruise ship", "cup", "diamond",
    "dishwasher", "dog", "dolphin", "donut", "door", "dragon", "dresser",
    "drill", "drums", "duck", "dumbbell", "ear", "elbow", "elephant",
    "envelope", "eraser", "eye", "eyeglasses", "face", "fan", "feather",
    "fence", "finger", "fire hydrant", "fireplace", "firetruck", "fish",
    "flamingo", "flashlight", "flip flops", "floor lamp", "flower",
    "flying saucer", "foot", "fork", "frog", "frying pan", "giraffe",
    "golf club", "grapes", "guitar", "tree"
];

// 🛠️ Toutes les catégories disponibles pour le mode en ligne
export const ALL_CATEGORIES = [
  "aircraft carrier", "airplane", "alarm clock", "ambulance", "angel",
  "animal migration", "ant", "anvil", "apple", "arm", "asparagus", "axe",
  "backpack", "banana", "bandage", "barn", "baseball", "basket",
  "basketball", "bat", "bathtub", "beach", "bear", "beard", "bed", "bee",
  "belt", "bench", "bicycle", "binoculars", "bird", "birthday cake",
  "blackberry", "blueberry", "book", "boomerang", "bottlecap", "bowtie",
  "bracelet", "brain", "bread", "bridge", "broccoli", "broom", "bucket",
  "bulldozer", "bus", "bush", "butterfly", "cactus", "cake", "calculator",
  "calendar", "camel", "camera", "campfire", "candle", "cannon", "canoe",
  "car", "carrot", "castle", "cat", "ceiling fan", "cello", "cell phone",
  "chair", "chandelier", "church", "circle", "clarinet", "clock", "cloud",
  "coffee cup", "compass", "computer", "cookie", "cooler", "couch", "cow",
  "crab", "crayon", "crocodile", "crown", "cruise ship", "cup", "diamond",
  "dishwasher", "dog", "dolphin", "donut", "door", "dragon", "dresser",
  "drill", "drums", "duck", "dumbbell", "ear", "elbow", "elephant",
  "envelope", "eraser", "eye", "eyeglasses", "face", "fan", "feather",
  "fence", "finger", "fire hydrant", "fireplace", "firetruck", "fish",
  "flamingo", "flashlight", "flip flops", "floor lamp", "flower",
  "flying saucer", "foot", "fork", "frog", "frying pan", "giraffe",
  "golf club", "grapes", "guitar", "hamburger", "hammer", "hat",
  "headphones", "helicopter", "helmet", "hockey stick", "horse",
  "hospital", "hot dog", "house", "ice cream", "key", "laptop", "leaf",
  "lion", "lobster", "map", "microphone", "motorbike", "mushroom", "ocean",
  "piano", "police car", "potato", "rabbit", "rainbow", "scissors",
  "shark", "sheep", "shoe", "snake", "snowman", "spider", "star", "sword",
  "tree", "t-shirt", "zebra"
];

// 🛠️ Traductions des catégories pour affichage côté utilisateur
export const CATEGORIES = {
  "cat": "chat",
  "fish": "poisson",
  "dog": "chien",
  "car": "voiture",
  "tree": "arbre",
  "airplane": "avion",
  "alarm clock": "réveil",
  "ambulance": "ambulance",
  "angel": "ange",
  "ant": "fourmi",
  "apple": "pomme",
  "arm": "bras",
  "backpack": "sac à dos",
  "banana": "banane",
  "basket": "panier",
  "bathtub": "baignoire",
  "beach": "plage",
  "bear": "ours",
  "beard": "barbe",
  "bed": "lit",
  "bicycle": "vélo",
  "bird": "oiseau",
  "book": "livre",
  "candle": "bougie",
  "carrot": "carotte",
  "castle": "château",
  "clock": "horloge",
  "cloud": "nuage",
  "computer": "ordinateur",
  "crocodile": "crocodile",
  "cup": "tasse",
  "dog": "chien",
  "dolphin": "dauphin",
  "door": "porte",
  "dragon": "dragon",
  "duck": "canard",
  "elephant": "éléphant",
  "firetruck": "camion de pompiers",
  "fish": "poisson",
  "flower": "fleur",
  "frog": "grenouille",
  "guitar": "guitare",
  "hamburger": "hamburger",
  "hat": "chapeau",
  "horse": "cheval",
  "house": "maison",
  "ice cream": "glace",
  "key": "clé",
  "leaf": "feuille",
  "lion": "lion",
  "rabbit": "lapin",
  "rainbow": "arc-en-ciel",
  "scissors": "ciseaux",
  "shark": "requin",
  "shoe": "chaussure",
  "snake": "serpent",
  "snowman": "bonhomme de neige",
  "spider": "araignée",
  "star": "étoile",
  "tree": "arbre",
  "t-shirt": "t-shirt",
  "zebra": "zèbre"
};

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