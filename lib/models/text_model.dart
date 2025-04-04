import 'dart:ui';

import 'image_model.dart';

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
  final List<ImageModel> images; // 🔥 Liste d’images associées

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
    this.textColor = "#000000",
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.normal,
    this.position = "below",
    this.images = const [], // Par défaut vide
  });

  factory TextModel.fromJson(Map<String, dynamic> json) {
    String fontWeightString = json['font_weight'] ?? 'normal';
    FontWeight fontWeight = _getFontWeight(fontWeightString);

    String textColor = json['text_color'] ?? '#000000';
    if (!RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(textColor)) {
      textColor = '#000000';
    }

    // 🔄 Conversion des images JSON en ImageModel
    List<ImageModel> images = [];

    if (json['image'] != null) {
      final imageData = json['image'];
      images.add(ImageModel(
        imageUrl: imageData['Image_Url'] ?? '',
        description: '',
        alignment: imageData['alignment'] ?? 'left',
        width: (imageData['width'] ?? 50).toDouble(),
        height: (imageData['height'] ?? 50).toDouble(),
      ));
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
      images: images, // ✅ assignation des images
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
      text: '',
      textColor: '#000000',
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      position: "above",
      images: [],
    );
  }
}
