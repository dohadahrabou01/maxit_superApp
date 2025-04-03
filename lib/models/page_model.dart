import 'button_model.dart';

class PageModel {
  final String name;
  final String content;
  final String backgroundImageUrl;
  final List<ButtonModel> buttons;

  PageModel({
    required this.name,
    required this.content,
    required this.backgroundImageUrl,
    required this.buttons,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    final buttonsJson = json['bouttons'] ?? [];

    // Affiche les données de buttonsJson dans la console
    print('buttonsJson: $buttonsJson');

    final buttonsList = buttonsJson is List ? buttonsJson : [];

    return PageModel(
      name: json['nom']?.toString() ?? 'Page sans nom',
      content: json['contenu']?.toString() ?? '',
      backgroundImageUrl: json['backgroundImage_url']?.toString() ?? '',
      buttons: buttonsList.isNotEmpty
          ? buttonsList.map((btn) {
        if (btn != null && btn is Map<String, dynamic>) {
          return ButtonModel.fromJson(btn);
        } else {
          return ButtonModel.defaultValue();
        }
      }).toList()
          : [],
    );
  }


}
