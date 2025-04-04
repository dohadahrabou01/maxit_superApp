import 'package:flutter/material.dart';
import '../services/cms_service.dart';
import '../models/page_model.dart';
import '../widgets/dynamic_button.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final CmsService _cmsService = CmsService();
  late Future<PageModel> _futurePage;

  @override
  void initState() {
    super.initState();
    _futurePage = _cmsService.fetchPage("welcome");
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
                onPressed: () => setState(() {
                  _futurePage = _cmsService.fetchPage("welcome");
                }),
                child: const Text("Réessayer"),
              ),
            );
          }

          final page = snapshot.data!;

          return Container(
            color: Color(int.parse(page.backgroundColor.replaceFirst('#', '0xff'))),
            child: Stack(
              children: [
                if (page.backgroundImageUrl.isNotEmpty)
                  Image.network(
                    page.backgroundImageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
                  ),

                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: page.buttons.map((btn) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: DynamicButton(button: btn),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
