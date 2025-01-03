import 'package:flutter/material.dart';

class JouerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jouer', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.yellow,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Écrivez ici',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }
}
