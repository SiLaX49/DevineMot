# 🖌️ **DevineMot**

**Un quiz interactif où des dessins absurdes deviennent des devinettes !**

---

## 📚 **Description du projet**

**DevineMot** est une application ludique où les joueurs doivent **deviner des dessins réalisés par d'autres utilisateurs**, inspirés par l'API **Quick, Draw!**. Les dessins sont souvent simples, parfois absurdes, et volontairement peu clairs, ajoutant une touche humoristique au défi.  

Les joueurs peuvent participer à des sessions de quiz, voter pour les dessins les plus hilarants, et conserver un historique de leurs scores.

---

## 🚀 **Technologies utilisées**

### **Frontend :**  
- **Flutter (Dart)** : Interface utilisateur moderne et multiplateforme.

### **Backend :**  
- **Node.js** avec **Express.js** : Serveur RESTful.  
- **MongoDB** avec **Mongoose** : Base de données NoSQL.  
- **dotenv** : Gestion sécurisée des variables d'environnement.  
- **cors** : Gestion des requêtes cross-origin.

---

## 🎮 **Fonctionnalités principales**

- 🎨 **Dessin avec Quick, Draw! :** Les utilisateurs dessinent des objets selon les suggestions de l'API **Quick, Draw!**.  
- 🧠 **Quiz interactif :** Les autres joueurs tentent de deviner ce que représentent les dessins parmi plusieurs propositions absurdes.  
- 🏆 **Système de score :** Chaque bonne réponse rapporte des points, et les scores sont sauvegardés pour les utilisateurs enregistrés.  
- 🖼️ **Galerie des meilleurs dessins :** Les joueurs peuvent voter pour les dessins les plus drôles ou les plus absurdes.  
- 🔒 **Authentification :** Jouer est possible sans connexion, mais s'enregistrer permet de sauvegarder ses scores et ses créations.  
- 📶 **Mode hors-ligne :** Jouer localement même sans connexion Internet.

---

## 🛠️ **Installation et Configuration**

### **Prérequis :**
- **Node.js**  
- **Flutter SDK**  
- **MongoDB**  

### **Installation Backend :**
```bash
git clone https://github.com/votre-repo/backend-devinemot.git
cd backend-devinemot
npm install
npm start
```

### **Installation Frontend :**
```bash
git clone https://github.com/votre-repo/frontend-devinemot.git
cd frontend-devinemot
flutter pub get
flutter run
```

---

## 🔑 **Variables d'environnement (.env)**

Exemple de configuration pour le backend :
```env
DB_URI=mongodb://localhost:27017/devinemot
JWT_SECRET=your_jwt_secret
PORT=3000
```

---

## 📊 **Organisation du projet (Git)**

- **main :** Branche principale, aucune modification directe.  
- **noa :** Branche de développement globale.  
- **sohail :** Branche de développement globale. 

---

## 🤝 **Contribuer au projet**

Les contributions sont les bienvenues !  
1. **Forkez** le projet.  
2. **Créez une branche :** `git checkout -b feature/your-feature`.  
3. **Commitez vos changements :** `git commit -m "Add some feature"`.  
4. **Pushez votre branche :** `git push origin feature/your-feature`.  
5. **Créez une Pull Request.**

---

## 📄 **Licence**

Ce projet est sous licence **MIT**. Consultez le fichier [LICENSE](LICENSE) pour plus de détails.

---

## 🧑‍💻 **Auteurs**

- **Noa Morisseau** – *développeur principal*  
- **Sohaïl Monnier** – *développeur principal*

---

## 🌟 **Objectif final**

Créer une expérience interactive amusante, où les utilisateurs peuvent dessiner, deviner, et rire ensemble autour de croquis délibérément chaotiques et humoristiques.
