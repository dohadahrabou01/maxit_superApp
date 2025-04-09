import 'package:flutter/material.dart';
import 'package:maxit/views/complete_page.dart';
import 'package:maxit/views/verification_page.dart';
import 'views/register_page.dart';
import 'views/login_page.dart';
import 'views/welcome_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      initialRoute: '/welcome',  // Page d'enregistrement initiale
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/welcome':
            return MaterialPageRoute(builder: (_) => WelcomePage());


          case '/login':
            return MaterialPageRoute(builder: (_) => LoginPage());

          case '/register':
            return MaterialPageRoute(builder: (_) => RegisterPage());
          case '/verifier':
            final numero = settings.arguments as String;  // Récupère l'argument passé
            return MaterialPageRoute(
              builder: (_) => PinVerificationPage(numero: numero), // Passe l'argument au constructeur
            );
          case '/complete':
            return MaterialPageRoute(builder: (_) => CompletePage());
          default:
            return MaterialPageRoute(builder: (_) => Scaffold(body: Center(child: Text("Page non trouvée"))));
        }
      },
    );
  }
}
