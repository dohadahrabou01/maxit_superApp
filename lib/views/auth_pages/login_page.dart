import 'package:flutter/material.dart';
import '../../services/cms_service/cms_service.dart';
import '../../models/page_model.dart';
import '../../models/text_model.dart';
import '../../services/auth_service/login_service.dart';
import '../../widgets/dynamic_button.dart';
import '../../widgets/dynamic_input.dart';
import '../../widgets/dynamic_text.dart'; // Importez le widget DynamicText

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final CmsService _cmsService = CmsService();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late Future<PageModel> _futurePage;

  @override
  void initState() {
    super.initState();
    _futurePage = _cmsService.fetchPage("login");
  }

  @override
  void dispose() {
    _numeroController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    final numero = _numeroController.text;
    final password = _passwordController.text;

    // Validation simple pour vérifier si les champs ne sont pas vides
    if (numero.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    final loginService = LoginService();
    loginService.sendOtp(numero, password).then((response) {
      print(response); // Traiter la réponse du serveur
      // Ajoute un traitement de la réponse si nécessaire
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/welcome',
                (route) => false,
          );
          return false;
        },
        child: Scaffold(
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
                        _futurePage = _cmsService.fetchPage("login");
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

                        // Affichage des inputs dynamiques avec contrôleurs
                        ...page.inputs.map((input) {
                          if (input.identifiant == "numero") {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: DynamicInput(input: input, controller: _numeroController),
                            );
                          } else if (input.identifiant == "password") {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: DynamicInput(input: input, controller: _passwordController),
                            );
                          }
                          return SizedBox(); // Si un autre champ, ne pas l'afficher
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/forget'); // Redirige vers la page de récupération du mot de passe
                            },
                            child: const Text(
                              "Mot de passe oublié ?",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),

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
                          child: DynamicButton(button: btn, onPressed: _submitLogin),
                        )),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}

