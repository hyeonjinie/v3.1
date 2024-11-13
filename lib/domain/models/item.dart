class Item {
  final String name;
  final String price;
  final String change;
  final String changePercent;
  final double isPredict;
  final String itemName;

  Item({
    required this.name,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.isPredict,
    required this.itemName,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] ?? 'Unknown',
      price: json['price'] ?? '0',
      change: json['change'] ?? '0',
      changePercent: json['changePercent'] ?? '0',
      isPredict: (json['isPredict'] ?? 0.0).toDouble(),
      itemName: json['item'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'change': change,
      'changePercent': changePercent,
      'isPredict': isPredict,
      'item': itemName,
    };
  }
}
