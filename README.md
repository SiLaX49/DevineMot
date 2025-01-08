Voici un **README.md** basé sur nos précédentes discussions, en reprenant les fonctionnalités et objectifs évoqués :

---

# 🖌️ **DevineMot**

**Un quiz interactif où une IA dessine, et vous devinez !**

## 📚 **Description du projet**

**DevineMot** est une application ludique où une **IA dessine des objets** de manière volontairement **exagérée et humoristique**, et les joueurs doivent **deviner ce que représente le dessin**. L'application est conçue pour offrir une expérience amusante et engageante, que ce soit en solo ou avec des amis.

## 🚀 **Technologies utilisées**

### **Frontend :**  
- **Flutter** (Dart) : Interface utilisateur dynamique et multiplateforme.

### **Backend :**  
- **Node.js** avec **Express.js** : Serveur RESTful.  
- **MongoDB** avec **Mongoose** : Base de données NoSQL.  
- **dotenv** : Gestion sécurisée des variables d'environnement.  
- **cors** : Gestion des requêtes cross-origin.

## 🎮 **Fonctionnalités principales**

- 🧠 **IA génératrice de dessins :** Intégration avec une API de type **Quick, Draw!** pour des esquisses générées aléatoirement.  
- 🎲 **Quiz interactif :** Les joueurs doivent choisir entre des options absurdes (ex. : poisson, chaussure, requin).  
- 🏆 **Système de score :** Historique des scores pour les utilisateurs connectés.  
- 🖼️ **Galerie des meilleurs dessins :** Les utilisateurs peuvent voter pour les dessins les plus "horribles".  
- 🔒 **Authentification :** Connexion facultative pour jouer, mais obligatoire pour sauvegarder les scores.  
- 🗣️ **Speech-to-Text :** Possibilité de deviner les réponses via la reconnaissance vocale.  
- 📶 **Mode hors-ligne :** Possibilité de jouer localement sans connexion Internet.  

## 🛠️ **Installation et Configuration**

### **Prérequis :**
- Node.js  
- Flutter SDK  
- MongoDB  

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

## 🔑 **Variables d'environnement (.env)**

Exemple de configuration pour le backend :
```
DB_URI=mongodb://localhost:27017/devinemot
JWT_SECRET=your_jwt_secret
PORT=3000
```

## 📊 **Organisation du projet (Git)**

- **main **: Branche principale, aucune modification directe.  
- **noa **: Branche de développement globale pour noa.  
- **sohail ** : Branche de développement globale pour sohail.
 
## 🤝 **Contribuer au projet**

Les contributions sont les bienvenues !  
1. Forkez le projet.  
2. Créez une branche : `git checkout -b feature/your-feature`.  
3. Commitez vos changements : `git commit -m "Add some feature"`.  
4. Pushez votre branche : `git push origin feature/your-feature`.  
5. Créez une Pull Request.

## 📄 **Licence**

Ce projet est sous licence **MIT**. Consultez le fichier [LICENSE](LICENSE) pour plus de détails.

## 🧑‍💻 **Auteurs**

- **Noa Morisseau** – *Chef de projet et développeur principal*  
- **Contributeurs** – *À compléter selon les membres de l'équipe*

## 🌟 **Objectif final**

Créer une expérience ludique unique, alliant technologie moderne et amusement, pour permettre aux utilisateurs de partager des moments drôles autour d'une IA aux dessins absurdes.

---

Qu'en penses-tu ? Souhaites-tu ajouter ou ajuster des sections ?
