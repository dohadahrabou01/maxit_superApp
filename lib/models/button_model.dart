import 'design_button_model.dart';

class ButtonModel {
  final String label;
  final String action;
  final DesignModel? design; // DesignModel qui contient les styles
 final String identifiant;
  ButtonModel({
    required this.label,
    required this.action,
    this.design, // design est facultatif ici
    required this.identifiant,
  });
  static ButtonModel defaultValue() {
    return ButtonModel(
      label: 'Bouton sans label',
      action: '', // Action vide par défaut
      identifiant: '',
    );
  }
  factory ButtonModel.fromJson(Map<String, dynamic> json) {
    return ButtonModel(
      label: json['label'] ?? 'Default Label',
      action: json['action'] ?? '',
      design: json['design'] != null ? DesignModel.fromJson(json['design']) : null,
      identifiant:json['identifiant']??'',
    );
  }
}
