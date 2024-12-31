import 'package:flutter/material.dart';
import './worst.dart';
import './jouer.dart';

class AccueilPage extends StatefulWidget {
  @override
  _AccueilPageState createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  int _selectedIndex = 0;

  // Déclaration des pages (context n'est pas utilisé directement ici)
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JouerPage()),
            );
          },
          child: Text('Jouer'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow, // Couleur du bouton
            foregroundColor: Colors.black, // Couleur du texte
          ),
        ),
      ),
      WorstDrawingPage(),
    ];
  }

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
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.yellow,
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
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
