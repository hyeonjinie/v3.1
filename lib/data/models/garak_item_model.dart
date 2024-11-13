import '../../domain/entities/garak_item.dart';

class GarakItemModel extends GarakItem {
  const GarakItemModel({
    required String name,
    required List<String> varieties,
  }) : super(name: name, varieties: varieties);

  factory GarakItemModel.fromJson(Map<String, dynamic> json) {
    return GarakItemModel(
      name: json.keys.first,
      varieties: List<String>.from(json.values.first),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      name: varieties,
    };
  }
}
