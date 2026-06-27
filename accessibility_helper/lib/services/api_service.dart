import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://trulyabled.onrender.com";

  static Future<List<String>> getRecommendations(
      String disability, String query) async {
    final response = await http.post(
      Uri.parse("$baseUrl/recommend"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "disability": disability,
        "query": query,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data["recommendations"]);
    } else {
      throw Exception("Failed to load recommendations");
    }
  }
}
