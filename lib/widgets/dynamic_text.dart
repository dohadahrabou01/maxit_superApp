import 'package:flutter/material.dart';
import '../models/text_model.dart';
import '../models/image_model.dart';

class DynamicTextWidget extends StatelessWidget {
  final TextModel textModel;

  const DynamicTextWidget({Key? key, required this.textModel}) : super(key: key);

  Color _parseColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) return Colors.black;
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.black;
    }
  }

  List<Widget> _buildImages(List<ImageModel> images) {
    return images.map((img) {
      return Image.network(
        img.imageUrl,
        width: img.width,
        height: img.height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 50, color: Colors.red);
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final leftImages = textModel.images.where((img) => img.alignment == 'left').toList();
    final rightImages = textModel.images.where((img) => img.alignment == 'right').toList();
    final aboveImages = textModel.images.where((img) => img.alignment == 'above').toList();
    final belowImages = textModel.images.where((img) => img.alignment == 'below').toList();

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._buildImages(aboveImages),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ..._buildImages(leftImages),
              SizedBox(width: 4), // Ajoute un petit espace entre l'image et le texte
              Flexible(
                child: Text(
                  textModel.text,
                  style: TextStyle(
                    color: _parseColor(textModel.textColor),
                    fontSize: textModel.fontSize,
                    fontWeight: textModel.fontWeight,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
              SizedBox(width: 6), // Ajoute un petit espace entre le texte et l'image à droite
              ..._buildImages(rightImages),
            ],
          ),
          ..._buildImages(belowImages),
        ],
      ),
    );
  }
}
