import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/page_model.dart';

class CmsService {
  static const String baseUrl = "http://10.0.2.2:1337/api";  // Mettre l'URL de ton Strapi

  Future<PageModel> fetchPage(String pageName) async {
    try {

      final response = await http.get(
          Uri.parse("$baseUrl/pages?filters[nom][\$eq]=$pageName&populate=bouttons.design")
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        print(body['data']);
        if (body['data'] == null || body['data'].isEmpty) {

          return PageModel.fromJson({});
        }
        if (body['data'] == null || body['data'].isEmpty) {
          throw Exception("Aucune page trouvée.");
        }
        final pageData = body['data'][0];
        print (body['data'][0]);
        print('pageData: $pageData');
        print('pageData[\'attributes\']: ${pageData['attributes']}');
        return PageModel.fromJson({
          ...pageData,
          ...?pageData['attributes'],  // Le '?...' garantit que si 'attributes' est null, il n'y aura pas d'exception
        });

      } else {
        throw Exception("Erreur HTTP ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
      throw Exception("Erreur de connexion: $e");
    }


}
}
