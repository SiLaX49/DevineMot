import 'package:flutter/material.dart';
import './worst.dart';

class AccueilPage extends StatefulWidget {
  @override
  _AccueilPageState createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(
      child: Text(
        'Bienvenue sur la page d\'accueil !',
        style: TextStyle(fontSize: 20),
      ),
    ),
    WorstDrawingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'Accueil' : 'Horrible Drawings',
          style: TextStyle(color: Colors.black), // Texte noir dans l'AppBar
        ),
        backgroundColor: Colors.yellow, // Couleur de fond jaune pour l'AppBar
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.yellow),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star, color: Colors.yellow),
            label: 'Horrible Drawings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellow, // Couleur jaune pour l'élément sélectionné
        unselectedItemColor: Colors.black, // Texte noir pour les autres éléments
        onTap: _onItemTapped,
      ),
    );
  }
}
