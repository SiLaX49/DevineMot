import jwt from "jsonwebtoken";

const verifyToken = (req, res, next) => {
  const authHeader = req.header("Authorization");

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ error: "Token manquant ou mal formaté" });
  }

  const token = authHeader.split(" ")[1];

  try {
    const verified = jwt.verify(token, process.env.JWT_SECRET);
    req.user = verified; // Ajoute les infos utilisateur dans req.user
    next();
  } catch (err) {
    console.error("❌ Token invalide :", err.message);
    res.status(403).json({ error: "Token invalide" });
  }
};

export default verifyToken;
