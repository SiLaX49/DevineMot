import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadRandomDrawing();
  }

  Future<void> _loadRandomDrawing() async {
    setState(() {
      isLoading = true;
      feedbackMessage = null;
    });

    try {
      final data = await ApiService.getRandomGameDrawing();
      setState(() {
        drawingData = data;
        isLoading = false;
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
      });
    } else {
      setState(() {
        feedbackMessage = '❌ Mauvaise réponse, essaye encore.';
      });
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
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Votre réponse',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                userAnswer = value;
              },
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
            ElevatedButton(
              onPressed: _loadRandomDrawing,
              child: Text('Nouveau Dessin'),
            ),
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
