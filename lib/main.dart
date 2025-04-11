import 'package:flutter/material.dart';
import 'package:maxit/views/auth_pages/complete_page.dart';
import 'package:maxit/views/auth_pages/forget_page.dart';
import 'package:maxit/views/auth_pages/reset_password_page.dart';
import 'package:maxit/views/auth_pages/verification_forget_page.dart';
import 'package:maxit/views/auth_pages/verification_page.dart';
import 'package:maxit/views/auth_pages/register_page.dart';
import 'package:maxit/views/auth_pages/login_page.dart';
import 'package:maxit/views/welcome_page.dart';

void main() {
  runApp(MyApp());
}

class AppRoutes {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String forget = '/forget';
  static const String register = '/register';
  static const String verifier = '/verifier';
  static const String verificationForget = '/verification-forget';
  static const String complete = '/complete';
  static const String resetPassword = '/reset-password';
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      initialRoute: AppRoutes.welcome,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.welcome:
            return MaterialPageRoute(builder: (_) => WelcomePage());

          case AppRoutes.login:
            return MaterialPageRoute(builder: (_) => LoginPage());

          case AppRoutes.forget:
            return MaterialPageRoute(builder: (_) => ForgetPage());

          case AppRoutes.register:
            return MaterialPageRoute(builder: (_) => RegisterPage());

          case AppRoutes.verifier:
            if (settings.arguments is String) {
              final numero = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => PinVerificationPage(numero: numero),
              );
            }
            return _errorRoute();

          case AppRoutes.verificationForget:
            if (settings.arguments is String) {
              final numero = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => PinVerificationForgetPage(numero: numero),
              );
            }
            return _errorRoute();

          case AppRoutes.complete:
            if (settings.arguments is String) {
              final numero = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => CompletePage(numero: numero),
              );
            }
            return _errorRoute();

          case AppRoutes.resetPassword:
            if (settings.arguments is String) {
              final numero = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => ResetPasswordPage(numero: numero),
              );
            }
            return _errorRoute();

          default:
            return _errorRoute();
        }
      },
    );
  }

  Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text("Erreur")),
        body: Center(
          child: Text("Page non trouvée ou arguments manquants."),
        ),
      ),
    );
  }
}
