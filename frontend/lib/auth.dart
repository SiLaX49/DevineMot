import 'package:flutter/material.dart';
import './accueil.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() {
    final email = emailController.text;
    final password = passwordController.text;

    if (email == 'test' && password == '123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AccueilPage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Identifiants incorrects.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Couleur de fond blanche
        elevation: 0, // Supprime l'ombre de l'AppBar
        centerTitle: true,
        title: Text(
          'Devine Mot',
          style: TextStyle(
            color: Colors.yellow, // Titre en jaune
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Bouton en jaune
                foregroundColor: Colors.black, // Texte du bouton en noir
              ),
              child: Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
