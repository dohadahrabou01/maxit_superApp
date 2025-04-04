import 'package:flutter/material.dart';
import '../models/text_model.dart';

class DynamicTextWidget extends StatelessWidget {
  final TextModel textModel;

  const DynamicTextWidget({Key? key, required this.textModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Déboguer la couleur pour voir ce que nous avons
    print('textColor: ${textModel.textColor}');  // Afficher la couleur reçue

    String? colorString = textModel.textColor;

    // Si la couleur est nulle ou vide, utiliser une couleur par défaut (ici, noir)
    if (colorString == null || colorString.isEmpty) {
      colorString = '#000000';  // Couleur noire par défaut
    }

    // Vérification si la chaîne commence par "#" et a une longueur de 7 (format hexadécimal)
    if (colorString.startsWith('#') && colorString.length == 7) {
      // Ajouter '0xFF' devant la couleur (en supposant qu'il s'agit d'une couleur hexadécimale RGB)
      colorString = '0xFF${colorString.substring(1)}';
    } else {
      // Si la chaîne n'est pas valide, attribuer une couleur par défaut et afficher un avertissement
      print('Erreur de format de couleur: $colorString');
      colorString = '0xFF000000';  // Utilisation d'une couleur noire par défaut
    }

    // Essayer de convertir la couleur en un entier. Si la conversion échoue, utiliser la couleur noire.
    Color color;
    try {
      color = Color(int.parse(colorString));
    } catch (e) {
      // Gestion d'une éventuelle erreur de parsing
      print('Erreur lors de la conversion de la couleur: $e');
      color = Colors.black;  // Couleur noire par défaut en cas d'erreur
    }

    return Container(
      margin: EdgeInsets.only(
        top: textModel.marginTop,
        right: textModel.marginRight,
        bottom: textModel.marginBottom,
        left: textModel.marginLeft,
      ),
      padding: EdgeInsets.only(
        top: textModel.paddingTop,
        right: textModel.paddingRight,
        bottom: textModel.paddingBottom,
        left: textModel.paddingLeft,
      ),
      child: Text(
        textModel.text,
        style: TextStyle(
          color: color,
          fontSize: textModel.fontSize,
          fontWeight: textModel.fontWeight,
        ),
      ),
    );
  }
}
