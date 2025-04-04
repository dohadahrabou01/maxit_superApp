import 'dart:ui';

class TextModel {
  final String text;
  final double marginTop;
  final double marginRight;
  final double marginBottom;
  final double marginLeft;
  final double paddingTop;
  final double paddingRight;
  final double paddingBottom;
  final double paddingLeft;
  final String textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final String position; // "above" ou "below"
  TextModel({
    required this.text,
    this.marginTop = 0.0,
    this.marginRight = 0.0,
    this.marginBottom = 0.0,
    this.marginLeft = 0.0,
    this.paddingTop = 0.0,
    this.paddingRight = 0.0,
    this.paddingBottom = 0.0,
    this.paddingLeft = 0.0,
    this.textColor = "#000000", // Couleur par défaut
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.normal,
    this.position = "below", // Par défaut, le texte est en dessous
  });

  factory TextModel.fromJson(Map<String, dynamic> json) {
    // Gestion du fontWeight avec une vérification plus robuste
    String fontWeightString = json['font_weight'] ?? 'normal';
    FontWeight fontWeight = _getFontWeight(fontWeightString);

    // Gestion de textColor
    String textColor = json['text_color'] ?? '#000000';
    // Vérification du format hexadécimal de la couleur
    if (!RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(textColor)) {
      textColor = '#000000'; // Valeur par défaut si la couleur est invalide
    }

    return TextModel(
      text: json['text'] ?? '',
      marginTop: json['margin_top']?.toDouble() ?? 0.0,
      marginRight: json['margin_right']?.toDouble() ?? 0.0,
      marginBottom: json['margin_bottom']?.toDouble() ?? 0.0,
      marginLeft: json['margin_left']?.toDouble() ?? 0.0,
      paddingTop: json['padding_top']?.toDouble() ?? 0.0,
      paddingRight: json['padding_right']?.toDouble() ?? 0.0,
      paddingBottom: json['padding_bottom']?.toDouble() ?? 0.0,
      paddingLeft: json['padding_left']?.toDouble() ?? 0.0,
      textColor: textColor,
      fontSize: json['font_size']?.toDouble() ?? 14.0,
      fontWeight: fontWeight,
      position: json['position'] ?? "below",
    );
  }

  static FontWeight _getFontWeight(String fontWeightString) {
    switch (fontWeightString.toLowerCase()) {
      case 'bold':
        return FontWeight.bold;
      case 'normal':
      default:
        return FontWeight.normal;
    }
  }

  static TextModel defaultValue() {
    return TextModel(
      text: '', // Texte par défaut vide
      marginTop: 0.0,
      marginRight: 0.0,
      marginBottom: 0.0,
      marginLeft: 0.0,
      paddingTop: 0.0,
      paddingRight: 0.0,
      paddingBottom: 0.0,
      paddingLeft: 0.0,
      textColor: '#000000', // Couleur du texte par défaut
      fontSize: 14.0, // Taille de police par défaut
      fontWeight: FontWeight.normal,
      position: "above",// Poids de police par défaut
    );
  }
}
