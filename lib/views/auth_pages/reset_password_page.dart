import 'package:flutter/material.dart';
import '../../services/cms_service/cms_service.dart';
import '../../services/auth_service/complete_service.dart';
import '../../models/page_model.dart';
import '../../models/text_model.dart';
import '../../services/auth_service/reset_password_service.dart';
import '../../widgets/dynamic_button.dart';
import '../../widgets/dynamic_input.dart';
import '../../widgets/dynamic_text.dart';

class ResetPasswordPage extends StatefulWidget {
  final String numero;

  const ResetPasswordPage({required this.numero, Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final CmsService _cmsService = CmsService();
  final ResetPasswordService _resetPasswordService = ResetPasswordService();

  late Future<PageModel> _futurePage;
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futurePage = _cmsService.fetchPage("reset-password");
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
                    _futurePage = _cmsService.fetchPage("reset-password");
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
                    // Textes au-dessus
                    ...page.texts.map((textModel) {
                      if (textModel.position == "above") {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: DynamicTextWidget(textModel: textModel),
                        );
                      }
                      return const SizedBox();
                    }),

                    // Inputs
                    ...page.inputs.map((input) {
                      if (input.identifiant == "password") {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: DynamicInput(
                            input: input,
                            controller: _passwordController, // Liaison au contrôleur
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: DynamicInput(input: input),
                        );
                      }
                    }),

                    // Textes en dessous
                    ...page.texts.map((textModel) {
                      if (textModel.position == "below") {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: DynamicTextWidget(textModel: textModel),
                        );
                      }
                      return const SizedBox();
                    }),

                    const SizedBox(height: 16),

                    // Boutons
                    ...page.buttons.map((btn) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DynamicButton(
                        button: btn,
                        onPressed: () async {
                          if (btn.identifiant == "modifier") {
                            String password = _passwordController.text.trim();

                            if (password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Veuillez entrer un mot de passe")),
                              );
                              return;
                            }

                            final response = await _resetPasswordService.verifyOtp(widget.numero, password);

                            if (response.startsWith("❌")) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(response)),
                              );
                            } else {
                              Navigator.pushNamed(context, btn.action); // Navigation dynamique
                            }
                          } else {
                            Navigator.pushNamed(context, btn.action);
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
