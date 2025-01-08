import 'package:flutter/material.dart';
import './accueil.dart';
import './api.dart';

/// Page d'authentification pour l'application.
/// Permet aux utilisateurs de se connecter ou de s'inscrire.
class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

/// État associé à la page d'authentification.
class _AuthPageState extends State<AuthPage> {
  // Contrôleurs pour capturer les entrées utilisateur.
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Mode actuel : Connexion (true) ou Inscription (false)
  bool isLoginMode = true;

  /// Méthode pour gérer l'authentification (connexion ou inscription)
  void _authenticate() async {
    final username = usernameController.text;
    final password = passwordController.text;
    final email = emailController.text;

    if (isLoginMode) {
      // Connexion
      final token = await ApiService.login(username, password);
      if (token != null) {
        // Redirection vers la page d'accueil après une connexion réussie
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AccueilPage()),
        );
      } else {
        _showErrorDialog('Échec de la connexion');
      }
    } else {
      // Inscription
      final success = await ApiService.register(username, email, password);
      if (success) {
        setState(() {
          isLoginMode = true; // Retour en mode Connexion après une inscription réussie
        });
      } else {
        _showErrorDialog('Échec de l\'inscription');
      }
    }
  }

  /// Affiche une boîte de dialogue d'erreur avec le message fourni.
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barre d'application avec titre centré et style personnalisé
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Suppression de l'ombre de l'AppBar
        centerTitle: true,
        title: Text(
          'Devine Mot',
          style: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),

      // Corps principal avec formulaire d'authentification
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Champ pour l'email (visible uniquement en mode Inscription)
            if (!isLoginMode)
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),

            // Champ pour le nom d'utilisateur
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
            ),

            // Champ pour le mot de passe
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true, // Cache le texte du mot de passe
            ),

            SizedBox(height: 20),

            // Bouton pour soumettre le formulaire (Connexion ou Inscription)
            ElevatedButton(
              onPressed: _authenticate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
              ),
              child: Text(isLoginMode ? 'Se connecter' : 'Créer un compte'),
            ),

            // Bouton pour basculer entre Connexion et Inscription
            TextButton(
              onPressed: () {
                setState(() {
                  isLoginMode = !isLoginMode; // Inverse le mode actuel
                });
              },
              child: Text(isLoginMode
                  ? 'Pas de compte ? Créez-en un'
                  : 'Vous avez déjà un compte ? Connectez-vous'),
            ),
          ],
        ),
      ),
    );
  }
}
