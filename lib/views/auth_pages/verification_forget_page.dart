import 'package:flutter/material.dart';
import '../../services/cms_service/cms_service.dart';
import '../../models/page_model.dart';
import '../../models/text_model.dart';
import '../../services/auth_service/verification_service.dart';  // Import du service de vérification
import '../../widgets/dynamic_button.dart';
import '../../widgets/dynamic_text.dart';
import 'dart:async'; // Importer la bibliothèque pour le Timer

class PinVerificationForgetPage extends StatefulWidget {
  final String numero;  // Assurez-vous de transmettre le numéro de téléphone

  PinVerificationForgetPage({required this.numero}); // Le numéro est passé via le constructeur

  @override
  _PinVerificationForgetPageState createState() => _PinVerificationForgetPageState();
}

class _PinVerificationForgetPageState extends State<PinVerificationForgetPage> {
  final CmsService _cmsService = CmsService();
  final VerificationService _verificationService = VerificationService(); // Service de vérification
  late Timer _timer;  // Déclaration du Timer
  int _counter = 60;  // Initialiser le compteur à 60 secondes
  bool _isResendEnabled = false;  // Booléen pour activer/désactiver le bouton de renvoi

  late Future<PageModel> _futurePage;
  final List<TextEditingController> _pinControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _pinFocusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _futurePage = _cmsService.fetchPage("verification-forget");
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _pinControllers) {
      controller.dispose();
    }
    for (var node in _pinFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _isResendEnabled = true;  // Activer le bouton de renvoi une fois le compteur arrivé à 0
        }
      });
    });
  }
  void _resendOtp() async {
    // Logique pour renvoyer le code OTP
    String numero = widget.numero;
    final response = await _verificationService.resendOtp(numero);
    print("Réponse du renvoi: $response");

    // Réinitialiser le compteur
    setState(() {
      _counter = 60;
      _isResendEnabled = false;
    });
    _startTimer();  // Redémarrer le compteur
  }

  Widget _buildPinInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          width: 50,
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: TextField(
            controller: _pinControllers[index],
            focusNode: _pinFocusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              counterText: "",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 2),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                FocusScope.of(context).requestFocus(_pinFocusNodes[index + 1]);
              }
              if (value.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(_pinFocusNodes[index - 1]);
              }

              // Quand le code est complet
              if (_pinControllers.every((c) => c.text.isNotEmpty)) {
                _verifyPin();
              }
            },
          ),
        );
      }),
    );
  }

  void _verifyPin() async {
    final pin = _pinControllers.map((c) => c.text).join();
    print("PIN saisi: $pin");
    String numero=widget.numero;
    print("numero:$numero ");

    // Appel de l'API pour vérifier l'OTP
    final response = await _verificationService.verifyOtp(widget.numero, pin);  // Utilisez le numéro passé
    print("Réponse du service: $response");

    // Affichage du résultat
    if (response.contains("✅")) {
      // Si la vérification est réussie, vous pouvez naviguer vers la page de saisie du mot de passe
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("OTP validé, veuillez entrer votre mot de passe")));
      Navigator.pushNamed(
        context,
        "/reset-password",
        arguments: widget.numero,
      );
      // Par exemple, rediriger vers la page de mot de passe
    } else {
      // Si l'OTP est invalide, afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
    }
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
                    _futurePage = _cmsService.fetchPage("verification-forget");
                  });
                },
                child: const Text("Réessayer"),
              ),
            );
          }

          final page = snapshot.data!;
          final aboveTexts = page.texts.where((t) => t.position == "above").toList();
          final belowTexts = page.texts.where((t) => t.position == "below").toList();

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
                    // Textes au-dessus des cases PIN
                    ...aboveTexts.map((textModel) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DynamicTextWidget(textModel: textModel),
                    )),

                    // Cases PIN
                    _buildPinInput(),
                    // Affichage du texte "Envoyé à $numero" en gris sous les cases PIN
                    Text(
                      "Envoyé à ${widget.numero}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),

// Affichage du compteur et du bouton pour renvoyer l'OTP
                    _isResendEnabled
                        ? ElevatedButton(
                      onPressed: _resendOtp,
                      child: const Text("Renvoyer le code"),
                    )
                        : Text(
                      "Réessayez dans $_counter secondes",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // Textes en-dessous des cases PIN
                    ...belowTexts.map((textModel) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DynamicTextWidget(textModel: textModel),
                    )),

                    const SizedBox(height: 16),

                    // Boutons dynamiques
                    ...page.buttons.map((btn) {
                      if (btn.identifiant == "verify") { // Vérifie si l'identifiant du bouton est "verify"
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: DynamicButton(
                              button: btn,
                              onPressed: () async {
                                // Appel de la fonction _verifyPin lorsque le bouton est cliqué
                                _verifyPin();
                              },
                            )
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: DynamicButton(button: btn),
                        );
                      }
                    }),
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
