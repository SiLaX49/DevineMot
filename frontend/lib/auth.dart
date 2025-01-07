import 'package:flutter/material.dart';
import './accueil.dart';
import './api.dart';


class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isLoginMode = true; // Toggle pour basculer entre Login et Register

  void _authenticate() async {
    final username = usernameController.text;
    final password = passwordController.text;
    final email = emailController.text;

    if (isLoginMode) {
      final token = await ApiService.login(username, password);
      if (token != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AccueilPage()),
        );
      } else {
        _showErrorDialog('Échec de la connexion');
      }
    } else {
      final success = await ApiService.register(username, email, password);
      if (success) {
        setState(() {
          isLoginMode = true;
        });
      } else {
        _showErrorDialog('Échec de l\'inscription');
      }
    }
  }

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isLoginMode)
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _authenticate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
              ),
              child: Text(isLoginMode ? 'Se connecter' : 'Créer un compte'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isLoginMode = !isLoginMode;
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
