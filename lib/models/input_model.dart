class InputModel {
  final String label;
  final String placeholder;
  final String type; // ✅ Nouveau champ ici
  final String backgroundColor;
  final String textColor;
  final String borderColor;
  final double borderWidth;
  final double borderRadius;
  final double marginTop;
  final double marginRight;
  final double marginBottom;
  final double marginLeft;
  final double paddingTop;
  final double paddingRight;
  final double paddingBottom;
  final double paddingLeft;
  final bool underline;
  final String underlineColor;
  final String identifiant;

  InputModel({
    required this.label,
    required this.placeholder,
    required this.type, // ✅ Ajouté ici
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.marginTop,
    required this.marginRight,
    required this.marginBottom,
    required this.marginLeft,
    required this.paddingTop,
    required this.paddingRight,
    required this.paddingBottom,
    required this.paddingLeft,
    required this.underline,
    required this.underlineColor,
    required this.identifiant,
  });

  factory InputModel.fromJson(Map<String, dynamic> json) {
    return InputModel(
      label: json['label'] ?? '',
      placeholder: json['placeholder'] ?? '',
      type: json['type'] ?? 'text', // ✅ Lecture depuis le JSON avec une valeur par défaut
      backgroundColor: json['background_color'] ?? '#FFFFFF',
      textColor: json['text_color'] ?? '#000000',
      borderColor: json['border_color'] ?? '#000000',
      borderWidth: json['border_width']?.toDouble() ?? 1.0,
      borderRadius: json['border_radius']?.toDouble() ?? 8.0,
      marginTop: json['margin_top']?.toDouble() ?? 0.0,
      marginRight: json['margin_right']?.toDouble() ?? 0.0,
      marginBottom: json['margin_bottom']?.toDouble() ?? 0.0,
      marginLeft: json['margin_left']?.toDouble() ?? 0.0,
      paddingTop: json['padding_top']?.toDouble() ?? 8.0,
      paddingRight: json['padding_right']?.toDouble() ?? 8.0,
      paddingBottom: json['padding_bottom']?.toDouble() ?? 8.0,
      paddingLeft: json['padding_left']?.toDouble() ?? 8.0,
      underline: json['underline'] ?? false,
      underlineColor: json['underline_color'] ?? '#000000',
        identifiant:json['identifiant']??'rien',
    );
  }

  static InputModel defaultValue() {
    return InputModel(
      label: 'Label par défaut',
      placeholder: 'Placeholder par défaut',
      type: 'text', // ✅ Valeur par défaut ici
      backgroundColor: '#FFFFFF',
      textColor: '#000000',
      borderColor: '#000000',
      borderWidth: 1.0,
      borderRadius: 8.0,
      marginTop: 0.0,
      marginRight: 0.0,
      marginBottom: 0.0,
      marginLeft: 0.0,
      paddingTop: 8.0,
      paddingRight: 8.0,
      paddingBottom: 8.0,
      paddingLeft: 8.0,
      underline: false,
      underlineColor: '#000000',
        identifiant:'rien',
    );
  }
}
