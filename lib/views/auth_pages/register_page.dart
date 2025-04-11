import 'package:flutter/material.dart';
import '../../services/cms_service/cms_service.dart';
import '../../models/page_model.dart';
import '../../models/text_model.dart';
import '../../services/auth_service/register_service.dart';
import '../../widgets/dynamic_button.dart';
import '../../widgets/dynamic_input.dart';
import '../../widgets/dynamic_text.dart'; // Importez le widget DynamicText

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final CmsService _cmsService = CmsService();
  final RegisterService _registerService = RegisterService();

  late Future<PageModel> _futurePage;
  TextEditingController _phoneController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _futurePage = _cmsService.fetchPage("register");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<PageModel>(
        future: _futurePage,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _futurePage = _cmsService.fetchPage("register");
                  });
                },
                child: const Text("Réessayer"),
              ),
            );
          }

          final page = snapshot.data!;

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(int.parse(page.backgroundColor.replaceFirst('#', '0xff'))),
              image: page.backgroundImageUrl.isNotEmpty
                  ? DecorationImage(
                image: NetworkImage(page.backgroundImageUrl),
                fit: BoxFit.cover,
                onError: (_, __) => const SizedBox(),
              )
                  : null,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Affichage des textes dynamiques
                    ...page.texts.map((textModel) {
                      if (textModel.position == "above") {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: DynamicTextWidget(textModel: textModel), // Affichage du texte au-dessus
                        );
                      }
                      return SizedBox(); // Si "below", on ne l'affiche pas encore
                    }),




                    ...page.inputs.map((input) {
                      if (input.identifiant == "numero") {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: DynamicInput(
                            input: input,
                            controller: _phoneController, // Liaison ici
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: DynamicInput(input: input),
                        );
                      }
                    }),


                    // Affichage des textes dynamiques qui viennent après les inputs
                    ...page.texts.map((textModel) {
                      if (textModel.position == "below") {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: DynamicTextWidget(textModel: textModel), // Affichage du texte en dessous
                        );
                      }
                      return SizedBox(); // Si "above", on ne l'affiche pas ici
                    }),

                    const SizedBox(height: 16),

                    // Affichage des boutons dynamiques
                    ...page.buttons.map((btn) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DynamicButton(
                        button: btn,
                        onPressed: () async {
                          if (btn.identifiant == "sendOtp") {
                            String numero = _phoneController.text.trim();

                            print("Numéro entré: $numero");  // Vérification du numéro

                            if (numero.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Veuillez entrer votre numéro de téléphone")),
                              );
                              return;
                            }

                            // Envoi de la requête
                            final response = await _registerService.sendOtp(numero);
                            print("Réponse du service: $response");  // Vérification de la réponse

                            if (response.startsWith("❌")) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(response)),
                              );
                            } else {
                              print("Réponse réussie, navigation vers la page OTP");
                              Navigator.pushNamed(
                                context,
                                btn.action,  // Utilisez l'action du bouton
                                arguments: numero,  // Passer le numéro comme argument
                              );// Navigue vers OTP
                            }
                          } else {
                            print("Réponse  non réussie");
                            Navigator.pushNamed(context, "/welcome");
                          }
                        },

                      ),
                    )),

                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
