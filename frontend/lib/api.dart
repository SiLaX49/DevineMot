import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String apiUrl = 'http://localhost:5000/api';

class ApiService {
  static Future<String?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      print('🔄 Status Code: ${response.statusCode}');
      print('🔄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final userId = data['userId']; // Récupération de l'ID utilisateur

        if (token == null) {
          throw Exception('Token manquant dans la réponse API');
        }

        final prefs = await SharedPreferences.getInstance();
        if (userId != null) {
          await prefs.setString('userId', userId); // Stocke l'ID utilisateur si disponible
          print('✅ User ID');
        } else {
          print('⚠️ Avertissement : User ID non retourné par l\'API');
        }

        print('✅ Token');
        return token;
      } else {
        throw Exception('Échec de la connexion : ${response.body}');
      }
    } catch (e) {
      print('❌ Erreur lors de la connexion : $e');
      rethrow;
    }
  }


  // Méthode pour obtenir un dessin aléatoire par catégorie
  static Future<Map<String, dynamic>?> getRandomDrawing({String category = 'cat'}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print('❌ Aucun token trouvé dans SharedPreferences');
      return null;
    }

    print('🔑 Token JWT ');

    final response = await http.get(
      Uri.parse('$apiUrl/drawings/random/$category'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('🔄 Status Code: ${response.statusCode}');
    print('🔄 Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('❌ Erreur API : ${response.statusCode}');
      print('❌ Détails : ${response.body}');
      return null;
    }
  }

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

    print('🔄 Status Code: ${response.statusCode}');
    print('🔄 Response Body: ${response.body}');

    if (response.statusCode != 201) {
      throw Exception('Erreur API : ${response.body}');
    }
  }


  static Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'email': email, 'password': password}),
    );

    return response.statusCode == 201;
  }

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
