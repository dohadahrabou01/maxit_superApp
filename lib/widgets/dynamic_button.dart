import 'package:flutter/material.dart';
import '../models/button_model.dart';

class DynamicButton extends StatelessWidget {
  final ButtonModel button;
  final double defaultSpacing = 12.0;

  const DynamicButton({required this.button, Key? key}) : super(key: key);

  Color _parseColor(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue; // Couleur de secours
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = button.design; // Utilise le design de ButtonModel

    // Valeurs par défaut si 'design' est null
    final backgroundColor = _parseColor(design?.backgroundColor ?? '#FFFFFF');
    final textColor = _parseColor(design?.textColor ?? '#000000');
    final textSize = design?.textSize ?? 16;
    final paddingLeft = design?.paddingLeft ?? 0;
    final paddingTop = design?.paddingTop ?? 0;
    final paddingRight = design?.paddingRight ?? 0;
    final paddingBottom = design?.paddingBottom ?? 0;
    final marginTop = design?.marginTop ?? 0;
    final marginLeft = design?.marginLeft ?? 0;
    final marginRight = design?.marginRight ?? 0;
    final marginBottom = design?.marginBottom ?? 0;
    final width = design?.width;
    final height = design?.height;
    final borderWidth = design?.border ?? 0; // Épaisseur de la bordure (0 si non définie)
    final borderColor = _parseColor(design?.borderColor ?? "#000000"); // Couleur de la bordure
    final borderRadius = design?.borderRadius ?? 8.0; // Rayon de bordure (par défaut 8.0)

    return Container(
      margin: EdgeInsets.fromLTRB(
          marginLeft,  // Marge à gauche
          marginTop,   // Marge en haut
          marginRight, // Marge à droite
          marginBottom // Marge en bas
      ),
      width: width,  // Appliquer la largeur si définie
      height: height, // Appliquer la hauteur si définie
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.fromLTRB(
            paddingLeft,
            paddingTop,
            paddingRight,
            paddingBottom,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius), // Utilisation du borderRadius
            side: BorderSide(
              color: borderColor, // Couleur de la bordure
              width: borderWidth, // Épaisseur de la bordure
            ),
          ),
          elevation: 4,
          shadowColor: Colors.black26,
        ),
        onPressed: () {
          // TODO: Implémenter la navigation selon button.action
          print("Action: ${button.action}");
          Navigator.pushNamed(context, button.action);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            button.label,
            style: TextStyle(
              color: textColor,
              fontSize: textSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
