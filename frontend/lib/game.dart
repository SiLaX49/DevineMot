import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import './api.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Map<String, dynamic>? drawingData;
  bool isLoading = true;
  String? userAnswer;
  String? feedbackMessage;
  bool showNextButton = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _loadRandomDrawing();
  }

  Future<void> _loadRandomDrawing() async {
    setState(() {
      isLoading = true;
      feedbackMessage = null;
      showNextButton = false;
    });

    try {
      final data = await ApiService.getRandomGameDrawing();
      setState(() {
        drawingData = data;
        isLoading = false;
      });
      Timer(Duration(seconds: 10), () {
        setState(() {
          showNextButton = true;
        });
      });
    } catch (e) {
      setState(() {
        feedbackMessage = 'Erreur : $e';
        isLoading = false;
      });
    }
  }

  void _validateAnswer() {
    if (userAnswer != null && userAnswer!.toLowerCase() == drawingData?['word'].toLowerCase()) {
      setState(() {
        feedbackMessage = '✅ Bonne réponse !';
        score += 10; // Ajoute 10 points pour une bonne réponse
        userAnswer = ''; // Réinitialise le texte
      });
    } else {
      setState(() {
        feedbackMessage = '❌ Mauvaise réponse, essaye encore.';
        userAnswer = ''; // Réinitialise le texte
      });
    }
  }

  Future<void> _saveDrawing() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur : Token manquant'))
        );
        return;
      }

      final image = drawingData?['image']; // Assure-toi que drawingData contient une URL d'image

      if (image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur : URL de l\'image manquante'))
        );
        return;
      }

      await ApiService.saveDrawing(image);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dessin ajouté à la galerie avec succès !'))
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e'))
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jeu - Devine le Mot'),
        backgroundColor: Colors.yellow,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Devine ce que représente ce dessin !', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Container(
              width: 300,
              height: 300,
              color: Colors.grey[200],
              child: CustomPaint(
                painter: DrawingPainter(drawingData?['drawing']),
              ),
            ),
            SizedBox(height: 10),
            IconButton(
              icon: Icon(Icons.star, color: Colors.yellow),
              onPressed: _saveDrawing,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Votre réponse',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                userAnswer = value;
              },
              controller: TextEditingController(text: userAnswer),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _validateAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
              ),
              child: Text('Valider'),
            ),
            if (feedbackMessage != null)
              Text(feedbackMessage!,
                  style: TextStyle(
                    fontSize: 16,
                    color: feedbackMessage!.contains('✅') ? Colors.green : Colors.red,
                  )),
            SizedBox(height: 20),
            if (showNextButton)
              ElevatedButton(
                onPressed: _loadRandomDrawing,
                child: Text('Suivant'),
              ),
            SizedBox(height: 20),
            Text('Score: $score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// 🎨 Dessin Vectoriel
class DrawingPainter extends CustomPainter {
  final List<dynamic>? drawing;

  DrawingPainter(this.drawing);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    if (drawing != null) {
      for (var stroke in drawing!) {
        for (int i = 0; i < stroke[0].length - 1; i++) {
          canvas.drawLine(
            Offset(stroke[0][i].toDouble(), stroke[1][i].toDouble()),
            Offset(stroke[0][i + 1].toDouble(), stroke[1][i + 1].toDouble()),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
