import 'package:flutter/material.dart';
import './api.dart';
import './auth.dart';
import './accueil.dart';
import './worst.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final user = await ApiService.autoLogin(); // Méthode pour vérifier le token

  runApp(MyApp(isLoggedIn: user != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? '/home' : '/auth',
      routes: {
        '/auth': (context) => AuthPage(),
        '/home': (context) => AccueilPage(),
        '/worst': (context) => WorstDrawingPage(),
        '/gallery': (context) => Scaffold(
          appBar: AppBar(
            title: Text('Galerie'),
            backgroundColor: Colors.yellow,
          ),
          body: Center(
            child: Text('Galerie en cours de développement'),
          ),
        ),
      },
    );
  }
}
