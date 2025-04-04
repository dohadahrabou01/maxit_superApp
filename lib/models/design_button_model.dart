class DesignModel {
  final String backgroundColor;
  final String textColor;
  final double textSize;
  final double? width;
  final double? height;
  final double? paddingTop;
  final double? paddingRight;
  final double? paddingBottom;
  final double? paddingLeft;
  final double? marginTop;
  final double? marginRight;
  final double? marginBottom;
  final double? marginLeft;
  final double? border; // Épaisseur de la bordure
  final String? borderColor; // Couleur de la bordure
  final double? borderRadius; // Rayon des bords (nouveau champ)

  DesignModel({
    required this.backgroundColor,
    required this.textColor,
    required this.textSize,
    this.width,
    this.height,
    this.paddingTop,
    this.paddingRight,
    this.paddingBottom,
    this.paddingLeft,
    this.marginTop,
    this.marginRight,
    this.marginBottom,
    this.marginLeft,
    this.border,
    this.borderColor,
    this.borderRadius, // Initialisation du nouveau champ
  });

  factory DesignModel.fromJson(Map<String, dynamic> json) {
    return DesignModel(
      backgroundColor: json['couleur_fond'] ?? "#FFFFFF",
      textColor: json['couleur_texte'] ?? "#000000",
      textSize: (json['taille_texte'] ?? 16).toDouble(),
      width: json['width'] != null ? (json['width'] as num).toDouble() : null,
      height: json['height'] != null ? (json['height'] as num).toDouble() : null,
      paddingTop: json['padding_top'] != null ? (json['padding_top'] as num).toDouble() : null,
      paddingRight: json['padding_right'] != null ? (json['padding_right'] as num).toDouble() : null,
      paddingBottom: json['padding_bottom'] != null ? (json['padding_bottom'] as num).toDouble() : null,
      paddingLeft: json['padding_left'] != null ? (json['padding_left'] as num).toDouble() : null,
      marginTop: json['margin_top'] != null ? (json['margin_top'] as num).toDouble() : null,
      marginRight: json['margin_right'] != null ? (json['margin_right'] as num).toDouble() : null,
      marginBottom: json['margin_bottom'] != null ? (json['margin_bottom'] as num).toDouble() : null,
      marginLeft: json['margin_left'] != null ? (json['margin_left'] as num).toDouble() : null,
      border: json['border'] != null ? (json['border'] as num).toDouble() : null,
      borderColor: json['border_color'] ?? "#000000", // Valeur par défaut
      borderRadius: json['border_radius'] != null ? (json['border_radius'] as num).toDouble() : null, // Gestion du rayon des bords
    );
  }
}
