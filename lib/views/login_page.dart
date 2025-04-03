import 'package:flutter/material.dart';
import '../services/cms_service.dart';
import '../models/page_model.dart';
import '../widgets/dynamic_button.dart';

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
          // Afficher un indicateur de chargement pendant l'attente des données
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Si une erreur se produit ou aucune donnée n'est trouvée
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    "Erreur: ${snapshot.error ?? 'Données non disponibles'}",
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _futurePage = _cmsService.fetchPage("welcome");
                    }),
                    child: const Text("Réessayer"),
                  ),
                ],
              ),
            );
          }

          final page = snapshot.data!;

          return Stack(
            children: [
              // Image de fond avec fallback
              if (page.backgroundImageUrl.isNotEmpty)
                Image.network(
                  page.backgroundImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
                )
              else
                Container(color: Colors.grey[200]),

              // Contenu principal de la page
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Affichage du contenu de la page
                      if (page.content.isNotEmpty)
                        Text(
                          page.content,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),

                      const SizedBox(height: 30),

                      // Affichage dynamique des boutons
                      ...page.buttons.map((btn) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: DynamicButton(button: btn),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
