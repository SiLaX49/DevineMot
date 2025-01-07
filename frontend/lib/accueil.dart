import 'package:flutter/material.dart';
import './api.dart';

import './worst.dart';
import './jouer.dart';

class AccueilPage extends StatefulWidget {
  @override
  _AccueilPageState createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  Map<String, dynamic>? drawing;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRandomDrawing();
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

  Future<void> _loadRandomDrawing() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await ApiService.getRandomDrawing();
      if (data != null) {
        setState(() {
          drawing = data;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Erreur : Impossible de charger le dessin.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur API : $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Devine le Mot'),
        title: Text(
          _selectedIndex == 0 ? 'Accueil' : 'Horrible Drawings',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.yellow,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage!,
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadRandomDrawing,
              child: Text('Réessayer'),
            )
          ],
        ),
      )
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            drawing!['imageUrl'] ?? '',
            height: 300,
            width: 300,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          Text(
            'Devine ce que représente ce dessin !',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Votre réponse',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              print('Réponse soumise');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              foregroundColor: Colors.black,
            ),
            child: Text('Valider'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadRandomDrawing,
            child: Text('Nouveau Dessin'),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.yellow,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: 0, // Page active
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/worst');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/gallery');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Pires Dessins',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Galerie',
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
