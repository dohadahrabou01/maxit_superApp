class ImageModel {
  final String imageUrl;
  final String description;
 // "above", "below", "left", "right"
  final String alignment; // "left" ou "right"
  final double width; // Largeur de l'image
  final double height; // Hauteur de l'image

  ImageModel({
    required this.imageUrl,
    required this.description,
// Valeur par défaut si position non définie
    this.alignment = "left", // Par défaut à gauche
    this.width = 100.0, // Valeur par défaut de la largeur
    this.height = 100.0, // Valeur par défaut de la hauteur
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      imageUrl: json['image_url'] ?? '',
      description: json['description'] ?? '',
// Valeur par défaut si position non définie
      alignment: json['alignment'] ?? "left", // Par défaut à gauche
      width: json['width']?.toDouble() ?? 100.0, // Valeur par défaut si non défini
      height: json['height']?.toDouble() ?? 100.0, // Valeur par défaut si non définie
    );
  }
}
