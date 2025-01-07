import jwt from "jsonwebtoken";
import User from "../models/User.js";

// Middleware pour vérifier les rôles
export const checkRole = (requiredRole) => {
  return async (req, res, next) => {
    try {
      const token = req.header("Authorization");
      if (!token) {
        return res.status(401).json({ error: "Access Denied: No Token Provided" });
      }

      // Décoder le token JWT
      const verified = jwt.verify(token, process.env.JWT_SECRET);
      req.user = verified;

      // Récupérer l'utilisateur depuis la base de données
      const user = await User.findById(req.user.id);
      if (!user) {
        return res.status(404).json({ error: "User not found" });
      }

      // Vérifier le rôle
      if (user.role !== requiredRole) {
        return res.status(403).json({ error: "Access Forbidden: Insufficient Role" });
      }

      next();
    } catch (err) {
      console.error("❌ Erreur de vérification du rôle :", err.message);
      res.status(400).json({ error: "Invalid Token or Role Verification Failed" });
    }
  };
};
