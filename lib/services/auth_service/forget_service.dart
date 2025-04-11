import 'package:http/http.dart' as http;

class ForgetService {
  final String baseUrl;

  ForgetService({this.baseUrl = "http://10.0.2.2:8888/AUTH-SERVICE/"}); // Remplace localhost par l'IP de ton backend si nécessaire

  Future<String> sendOtp(String numero) async {
    final uri = Uri.parse("$baseUrl/auth/forgot-password");

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'numero': numero,
        },
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
