import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// URL de base de l'API
const String apiUrl = 'http://localhost:5000/api';

/// Service API pour gérer les interactions avec le backend.
class ApiService {
  /// Méthode de connexion utilisateur.
  /// Retourne le token JWT en cas de succès.
  static Future<String?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      print('Statut de la réponse : ${response.statusCode}');
      print('Corps de la réponse : ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final userId = data['userId'];

        if (token == null) {
          throw Exception('Token manquant dans la réponse API');
        }

        final prefs = await SharedPreferences.getInstance();
        if (userId != null) {
          await prefs.setString('userId', userId); // Enregistre l'ID utilisateur
          print('User ID enregistré');
        } else {
          print('Avertissement : User ID non retourné par l\'API');
        }

        print('Token enregistré');
        return token;
      } else {
        throw Exception('Échec de la connexion : ${response.body}');
      }
    } catch (e) {
      print('Erreur lors de la connexion : $e');
      rethrow;
    }
  }

  /// Récupère un dessin aléatoire par catégorie.
  /// Retourne un objet JSON contenant les détails du dessin.
  static Future<Map<String, dynamic>?> getRandomDrawing({String category = 'cat'}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print('Aucun token trouvé dans SharedPreferences');
      return null;
    }

    print('Token JWT valide');

    final response = await http.get(
      Uri.parse('$apiUrl/drawings/random/$category'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Statut de la réponse : ${response.statusCode}');
    print('Corps de la réponse : ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Erreur API : ${response.statusCode}');
      print('Détails : ${response.body}');
      return null;
    }
  }

  /// Récupère les données de jeu.
  /// Retourne un objet JSON avec les informations du jeu.
  static Future<Map<String, dynamic>> getGameData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token manquant');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/game'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur API : ${response.body}');
    }
  }

  /// Enregistre un dessin dans la galerie.
  static Future<void> saveDrawing(String image) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token manquant');
    }

    final response = await http.post(
      Uri.parse('$apiUrl/gallery/add'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'image': image}),
    );

    print('Statut de la réponse : ${response.statusCode}');
    print('Corps de la réponse : ${response.body}');

    if (response.statusCode != 201) {
      throw Exception('Erreur API : ${response.body}');
    }
  }

  /// Méthode d'inscription utilisateur.
  /// Retourne `true` si l'inscription réussit.
  static Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'email': email, 'password': password}),
    );

    return response.statusCode == 201;
  }

  /// Vérifie si l'utilisateur est toujours connecté.
  /// Retourne les informations utilisateur si le token est valide.
  static Future<Map<String, dynamic>?> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$apiUrl/auth/auto-login'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  /// Récupère un dessin aléatoire pour le jeu.
  /// Retourne un objet JSON avec les détails du dessin.
  static Future<Map<String, dynamic>> getRandomGameDrawing() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token manquant');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/game/random'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur API : ${response.body}');
    }
  }
}
