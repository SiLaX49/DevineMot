import 'package:flutter/material.dart';
import './api.dart';

/// Classe principale représentant la page d'accueil de l'application.
class AccueilPage extends StatefulWidget {
  @override
  _AccueilPageState createState() => _AccueilPageState();
}

/// État associé à la page d'accueil.
class _AccueilPageState extends State<AccueilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barre d'application (AppBar) avec titre centré et couleur personnalisée
      appBar: AppBar(
        title: Text('Devine le Mot'),
        backgroundColor: Colors.yellow, // Couleur de fond de la barre d'application
        centerTitle: true, // Centre le titre dans l'AppBar
      ),

      // Corps principal de la page
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centre les enfants verticalement
          children: [
            // Texte de bienvenue
            Text(
              'Bienvenue dans Devine le Mot !',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Espacement entre les widgets

            // Bouton pour lancer le jeu
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/game'); // Navigation vers la page du jeu
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Couleur de fond du bouton
                foregroundColor: Colors.black, // Couleur du texte
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Espacement interne
              ),
              child: Text(
                'Jouer',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),

      // Barre de navigation en bas de page
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.yellow, // Couleur de fond de la barre de navigation
        selectedItemColor: Colors.black, // Couleur de l'élément sélectionné
        unselectedItemColor: Colors.grey, // Couleur des éléments non sélectionnés
        currentIndex: 0, // Index de l'élément actuellement sélectionné
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/'); // Retour à la page d'accueil
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/worst'); // Aller à la page "Pires Dessins"
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Icône pour l'accueil
            label: 'Accueil', // Texte associé
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star), // Icône pour les "pires dessins"
            label: 'Pires Dessins', // Texte associé
          ),
        ],
      ),
    );
  }
}
