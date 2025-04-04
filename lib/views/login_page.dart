import 'package:flutter/material.dart';
import '../services/cms_service.dart';
import '../models/page_model.dart';
import '../models/text_model.dart';
import '../widgets/dynamic_button.dart';
import '../widgets/dynamic_input.dart';
import '../widgets/dynamic_text.dart'; // Importez le widget DynamicText

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final CmsService _cmsService = CmsService();
  late Future<PageModel> _futurePage;

  @override
  void initState() {
    super.initState();
    _futurePage = _cmsService.fetchPage("login");
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

                    // Affichage des inputs dynamiques
                    ...page.inputs.map((input) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DynamicInput(input: input),
                    )),

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
                      child: DynamicButton(button: btn),
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
