import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String apiUrl = 'http://localhost:5000/api';

class ApiService {
  static Future<String?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      return token;
    }
    return null;
  }

  // Méthode pour obtenir un dessin aléatoire par catégorie
  static Future<Map<String, dynamic>?> getRandomDrawing({String category = 'cat'}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print('❌ Aucun token trouvé dans SharedPreferences');
      return null;
    }

    print('🔑 Token JWT : $token');

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
}
