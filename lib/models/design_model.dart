class DesignModel {
  final String backgroundColor;
  final String textColor;
  final double textSize;
  final double? paddingTop;
  final double? paddingRight;
  final double? paddingBottom;
  final double? paddingLeft;
  final double? marginTop;
  final double? marginRight;
  final double? marginBottom;
  final double? marginLeft;

  DesignModel({
    required this.backgroundColor,
    required this.textColor,
    required this.textSize,
    this.paddingTop,
    this.paddingRight,
    this.paddingBottom,
    this.paddingLeft,
    this.marginTop,
    this.marginRight,
    this.marginBottom,
    this.marginLeft,
  });

  factory DesignModel.fromJson(Map<String, dynamic> json) {
    json ??= {}; // On s'assure que json n'est pas null.

    return DesignModel(
      backgroundColor: json['couleur_fond'] ?? "#FFFFFF", // Valeur par défaut
      textColor: json['couleur_texte'] ?? "#000000", // Valeur par défaut
      textSize: (json['taille_texte'] ?? 16).toDouble(), // Valeur par défaut
      paddingTop: json['padding_top'] != null ? (json['padding_top'] as num).toDouble() : null,
      paddingRight: json['padding_right'] != null ? (json['padding_right'] as num).toDouble() : null,
      paddingBottom: json['padding_bottom'] != null ? (json['padding_bottom'] as num).toDouble() : null,
      paddingLeft: json['padding_left'] != null ? (json['padding_left'] as num).toDouble() : null,
      marginTop: json['margin_top'] != null ? (json['margin_top'] as num).toDouble() : null,
      marginRight: json['margin_right'] != null ? (json['margin_right'] as num).toDouble() : null,
      marginBottom: json['margin_bottom'] != null ? (json['margin_bottom'] as num).toDouble() : null,
      marginLeft: json['margin_left'] != null ? (json['margin_left'] as num).toDouble() : null,
    );
  }
}
