import 'dart:convert';
import 'package:http/http.dart' as http;

class ResetPasswordService {
  Future<String> verifyOtp(String numero, String password) async {
    final url = Uri.parse('http://10.0.2.2:8888/AUTH-SERVICE/auth/reset-password'); // Remplacez par l'URL de votre API

    final response = await http.post(
      url,
      body: {
        'numero': numero,
        'newPassword': password,
      },
    );

    if (response.statusCode == 200) {
      // Si la réponse est OK, retourner le message
      return response.body;
    } else {
      // Si la réponse échoue, retourner l'erreur
      return "❌ Erreur: ${response.body}";
    }
  }

  resendOtp(String numero) {}
}
