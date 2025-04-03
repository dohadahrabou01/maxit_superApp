import 'package:flutter/material.dart';
import 'views/login_page.dart';
import 'views/welcome_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',  // Définit la page de bienvenue comme première page
      routes: {
        '/': (context) => WelcomePage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
