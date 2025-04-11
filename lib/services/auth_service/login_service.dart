import 'package:http/http.dart' as http;
import 'dart:convert';  // Pour convertir les objets en JSON

class LoginService {
  final String baseUrl;

  LoginService({this.baseUrl = "http://10.0.2.2:8888/AUTH-SERVICE/"}); // Remplace localhost par l'IP de ton backend si nécessaire

  Future<String> sendOtp(String numero, String password) async {
    final uri = Uri.parse("$baseUrl/auth/login");

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json', // Utilise application/json
        },
        body: jsonEncode({ // Convertit ton corps en JSON
          'numero': numero,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return response.body; // ✅ Code OTP envoyé
      } else {
        return "❌ ${response.body}";
      }
    } catch (e) {
      return "❌ Erreur lors de l’envoi: $e";
    }
  }
}
