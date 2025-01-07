@echo off
echo 📦 Mise à jour des dépendances Backend...
cd backend
npm install

echo 🛠️ Démarrage du Backend...
start cmd /k "npm run start"
timeout /t 5

cd ../frontend
echo 📦 Mise à jour des dépendances Frontend...
flutter pub get

echo 📱 Démarrage du Frontend...
flutter run
