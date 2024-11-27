import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/index.dart';
import 'package:v3_mvp/screens/info_center/subscription/new_subscription/models/product.dart';

class ProductSelection {
  final Product product;
  final String term;
  final String market;
  final int selectedPrice;

  ProductSelection({
    required this.product,
    required this.term,
    required this.market,
    required this.selectedPrice,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProductSelection &&
              runtimeType == other.runtimeType &&
              product == other.product &&
              term == other.term &&
              market == other.market &&
              selectedPrice == other.selectedPrice;

  @override
  int get hashCode => product.hashCode ^ term.hashCode ^ market.hashCode ^ selectedPrice.hashCode;
}

class IndexSelection {
  final Index index;
  final String term;
  final String type;

  IndexSelection({
    required this.index,
    required this.term,
    required this.type,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is IndexSelection &&
              runtimeType == other.runtimeType &&
              index == other.index &&
              term == other.term &&
              type == other.type;

  @override
  int get hashCode => index.hashCode ^ term.hashCode ^ type.hashCode;
}