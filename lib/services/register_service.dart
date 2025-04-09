import 'package:http/http.dart' as http;

class RegisterService {
  final String baseUrl;

  RegisterService({this.baseUrl = "http://10.0.2.2:9009"}); // Remplace localhost par l'IP de ton backend si nécessaire

  Future<String> sendOtp(String phoneNumber) async {
    final uri = Uri.parse("$baseUrl/auth/register/send");

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'phoneNumber': phoneNumber,
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
