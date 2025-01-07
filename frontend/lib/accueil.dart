import 'package:flutter/material.dart';
import './api.dart';

class AccueilPage extends StatefulWidget {
  @override
  _AccueilPageState createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Devine le Mot'),
        backgroundColor: Colors.yellow,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenue dans Devine le Mot !',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/game');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: Text(
                'Jouer',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.yellow,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/worst');
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
        ],
      ),
    );
  }
}
