import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import './api.dart';

/// Page principale du jeu.
/// Permet aux utilisateurs de deviner un mot à partir d'un dessin généré par l'IA.
class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

/// État associé à la page du jeu.
class _GamePageState extends State<GamePage> {
  Map<String, dynamic>? drawingData; // Données du dessin actuel
  bool isLoading = true; // Indique si le dessin est en cours de chargement
  String? userAnswer; // Réponse de l'utilisateur
  String? feedbackMessage; // Message de validation de la réponse
  bool showNextButton = false; // Affiche le bouton suivant après un délai
  int score = 0; // Score de l'utilisateur

  @override
  void initState() {
    super.initState();
    _loadRandomDrawing();
  }

  /// Charge un dessin aléatoire depuis l'API.
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

      // Affiche le bouton "Suivant" après 10 secondes
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

  /// Valide la réponse de l'utilisateur.
  void _validateAnswer() {
    if (userAnswer != null &&
        userAnswer!.toLowerCase() == drawingData?['word'].toLowerCase()) {
      setState(() {
        feedbackMessage = 'Bonne réponse !';
        score += 10; // Ajoute 10 points pour une bonne réponse
        userAnswer = ''; // Réinitialise le texte
      });
    } else {
      setState(() {
        feedbackMessage = 'Mauvaise réponse, essaye encore.';
        userAnswer = ''; // Réinitialise le texte
      });
    }
  }

  /// Sauvegarde le dessin actuel dans la galerie.
  Future<void> _saveDrawing() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : Token manquant')),
        );
        return;
      }

      final image = drawingData?['image']; // URL du dessin

      if (image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : URL de l\'image manquante')),
        );
        return;
      }

      await ApiService.saveDrawing(image);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dessin ajouté à la galerie avec succès !')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
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
            // Instructions du jeu
            Text('Devine ce que représente ce dessin !',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),

            // Zone d'affichage du dessin
            Container(
              width: 300,
              height: 300,
              color: Colors.grey[200],
              child: CustomPaint(
                painter: DrawingPainter(drawingData?['drawing']),
              ),
            ),
            SizedBox(height: 10),

            // Bouton pour sauvegarder le dessin
            IconButton(
              icon: Icon(Icons.star, color: Colors.yellow),
              onPressed: _saveDrawing,
            ),
            SizedBox(height: 20),

            // Champ de texte pour la réponse de l'utilisateur
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

            // Bouton de validation de la réponse
            ElevatedButton(
              onPressed: _validateAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
              ),
              child: Text('Valider'),
            ),

            // Affichage du message de feedback
            if (feedbackMessage != null)
              Text(
                feedbackMessage!,
                style: TextStyle(
                  fontSize: 16,
                  color: feedbackMessage!.contains('Bonne')
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            SizedBox(height: 20),

            // Bouton pour passer au dessin suivant
            if (showNextButton)
              ElevatedButton(
                onPressed: _loadRandomDrawing,
                child: Text('Suivant'),
              ),
            SizedBox(height: 20),

            // Affichage du score
            Text('Score: $score',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

/// Classe pour dessiner le croquis vectoriel sur le canvas.
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
