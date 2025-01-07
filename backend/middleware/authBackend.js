export const basicAuth = (req, res, next) => {
  const authHeader = req.headers["authorization"];
  if (!authHeader) {
    return res.status(401).json({ error: "Authentification requise." });
  }

  const base64Credentials = authHeader.split(" ")[1];
  const credentials = Buffer.from(base64Credentials, "base64").toString("utf8");
  const [username, password] = credentials.split(":");

  const PREDEFINED_USER = { username: "admin", password: "admin" };

  if (username === PREDEFINED_USER.username && password === PREDEFINED_USER.password) {
    next();
  } else {
    return res.status(403).json({ error: "Accès interdit : identifiants invalides." });
  }
};
