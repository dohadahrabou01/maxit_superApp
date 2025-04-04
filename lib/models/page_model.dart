import 'text_model.dart';

import 'input_model.dart';
import 'button_model.dart';

class PageModel {
  final String name;
  final String backgroundImageUrl;
  final String backgroundColor;
  final List<ButtonModel> buttons;
  final List<InputModel> inputs;  // Liste des inputs
  final List<TextModel> texts;

  PageModel({
    required this.name,
    required this.backgroundImageUrl,
    required this.backgroundColor,
    required this.buttons,
    required this.inputs,
    required this.texts,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    final buttonsJson = json['bouttons'] ?? [];
    final inputsJson = json['inputs'] ?? [];  // Ajout des inputs
    final textsJson = json['texts'] ?? [];
    // Affiche les données des buttons et des inputs dans la console
    print('buttonsJson: $buttonsJson');
    print('inputsJson: $inputsJson');
    print('textsJson: $textsJson');

    final buttonsList = buttonsJson is List ? buttonsJson : [];
    final inputsList = inputsJson is List ? inputsJson : [];  // Conversion des inputs en liste
    final textsList = textsJson is List ? textsJson : [];
    return PageModel(
      name: json['nom']?.toString() ?? 'Page sans nom',
      backgroundImageUrl: json['backgroundImage_url']?.toString() ?? '',
      backgroundColor: json['background_color']?.toString() ?? '#FFFFFF',
      buttons: buttonsList.isNotEmpty
          ? buttonsList.map((btn) {
        if (btn != null && btn is Map<String, dynamic>) {
          return ButtonModel.fromJson(btn);
        } else {
          return ButtonModel.defaultValue();
        }
      }).toList()
          : [],
      inputs: inputsList.isNotEmpty
          ? inputsList.map((input) {
        if (input != null && input is Map<String, dynamic>) {
          return InputModel.fromJson(input);  // Conversion des inputs
        } else {
          return InputModel.defaultValue();  // Valeur par défaut si input est null
        }
      }).toList()
          : [],
      texts: textsList.isNotEmpty
        ? textsList.map((text) {
      if (text != null && text is Map<String, dynamic>) {
        return TextModel.fromJson(text);  // Conversion des textes
      } else {
        return TextModel.defaultValue();  // Valeur par défaut si texte est null
      }
    }).toList()
        : [],
    );

  }
}
