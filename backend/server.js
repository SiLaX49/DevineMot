import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import cors from "cors";
import bodyParser from "body-parser";
import path from "path";
import fs from "fs-extra";
import axios from "axios";
import isOnline from "is-online";
import { fileURLToPath } from "url";

// Recréation de __dirname pour ES Modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Importation des routes
import authRoutes from "./routes/auth.js";
import gamesRoutes from "./routes/games.js";
import galleryRoutes from "./routes/gallery.js";
import drawingsRoutes from "./routes/drawings.js";

dotenv.config();

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Dossier pour stocker les dessins
const DATA_DIR = path.join(__dirname, "data");
const DRAWING_CATEGORIES = ["cat", "shoe", "fish"];
const BASE_URL = "https://storage.googleapis.com/quickdraw_dataset/full/simplified";

// Fonction pour vérifier et télécharger les fichiers NDJSON
async function downloadDrawings() {
  console.log("Vérification des fichiers NDJSON...");
  await fs.ensureDir(DATA_DIR);

  for (const category of DRAWING_CATEGORIES) {
    const localFilePath = path.join(DATA_DIR, `${category}.ndjson`);

    if (!fs.existsSync(localFilePath)) {
      try {
        console.log(`Téléchargement de ${category}...`);
        const url = `${BASE_URL}/${category}.ndjson`;
        const response = await axios.get(url, { responseType: "stream" });

        const writer = fs.createWriteStream(localFilePath);
        response.data.pipe(writer);

        await new Promise((resolve, reject) => {
          writer.on("finish", resolve);
          writer.on("error", reject);
        });

        console.log(`${category}.ndjson téléchargé avec succès.`);
      } catch (error) {
        console.error(`Erreur lors du téléchargement de ${category}:`, error.message);
      }
    } else {
      console.log(`${category}.ndjson déjà présent.`);
    }
  }
}

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/drawings", drawingsRoutes);
app.use("/api/games", gamesRoutes);
app.use("/api/gallery", galleryRoutes);

// Connexion à MongoDB
mongoose
  .connect(process.env.MONGO_URI)
  .then(async () => {
    console.log("MongoDB connected");
    await downloadDrawings();
    const PORT = process.env.PORT || 5000;
    app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
  })
  .catch((err) => console.log("MongoDB connection error:", err));
