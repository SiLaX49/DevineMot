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
import gallery from "./routes/gallery.js";
import drawingsRoutes from "./routes/drawings.js";
import adminRoutes from "./routes/admin.js";
import verifyToken from "./utils/verifyToken.js";
import { checkRole } from "./middleware/roleMiddleware.js";
import { basicAuth } from "./middleware/authBackend.js";
import { BASE_URL } from "./routes/games.js";

// Chargement des variables d'environnement
dotenv.config();

// Initialisation de l'application Express
const app = express();
app.use(cors()); // Gestion des politiques de sécurité CORS
app.use(bodyParser.json()); // Parse les requêtes JSON


// Route de base pour vérifier que l'API est fonctionnelle
app.get("/", (req, res) => {
  res.status(200).json({
    message: "Bienvenue sur l'API DevineMot ! Utilisez /api/auth/login pour vous connecter.",
  });
});


// Importation des catégories de dessins depuis games.js
import { DRAWING_CATEGORIES } from "./routes/games.js";

// Définition du dossier de stockage des fichiers NDJSON
const DATA_DIR = path.join(__dirname, "data");

/**
 * Télécharge les fichiers NDJSON pour chaque catégorie de dessin.
 */
async function downloadDrawings() {
  console.log("Vérification et téléchargement des fichiers NDJSON...");
  await fs.ensureDir(DATA_DIR); // S'assure que le dossier existe

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



// Routes publiques (authentification)
app.use("/api/auth", authRoutes);

// Routes protégées par JWT (Token requis pour accéder)
app.use("/api/drawings", verifyToken, drawingsRoutes);
app.use("/api", verifyToken, gamesRoutes);
app.use("/api/gallery", verifyToken, gallery);

// Routes Admin (Accès restreint)
app.use("/api/admin", adminRoutes);

// Route protégée par une authentification basique
app.use("/api/sensitive", basicAuth, (req, res) => {
  res.status(200).json({ message: "Route sensible avec Basic Auth." });
});


// Connexion à la base de données MongoDB
mongoose
  .connect(process.env.MONGO_URI)
  .then(async () => {
    console.log("MongoDB connecté");
    await downloadDrawings(); // Téléchargement des fichiers NDJSON
    const PORT = process.env.PORT || 5000;
    app.listen(PORT, () => console.log(`Serveur en cours d'exécution sur le port ${PORT}`));
  })
  .catch((err) => console.log("Erreur de connexion MongoDB :", err));
