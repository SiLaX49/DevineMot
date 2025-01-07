import 'package:flutter/material.dart';
import './api.dart';

class WorstDrawingPage extends StatefulWidget {
  @override
  _WorstDrawingPageState createState() => _WorstDrawingPageState();
}

class _WorstDrawingPageState extends State<WorstDrawingPage> {
  Map<String, dynamic>? drawing;

  void _loadRandomDrawing() async {
    final data = await ApiService.getRandomDrawing();
    setState(() {
      drawing = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadRandomDrawing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Les Pires Dessins'),
        backgroundColor: Colors.yellow,
        centerTitle: true,
      ),
      body: drawing == null
          ? Center(child: CircularProgressIndicator())
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            drawing!['imageUrl'],
            height: 300,
            width: 300,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          Text(
            'Mot associé : ${drawing!['word']}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadRandomDrawing,
            child: Text('Voir un autre dessin horrible'),
          ),
        ],
      ),
    );
  }
}
