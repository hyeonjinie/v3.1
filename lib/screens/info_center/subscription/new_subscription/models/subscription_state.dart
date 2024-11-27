import 'package:flutter/foundation.dart';

@immutable
class SubscriptionState {
  final String? selectedCategory;
  final String? selectedSubtype;
  final String? selectedDetail;
  final List<String> availableCategories;
  final List<String> availableSubtypes;
  final List<String> availableDetails;

  const SubscriptionState({
    this.selectedCategory,
    this.selectedSubtype,
    this.selectedDetail,
    this.availableCategories = const [],
    this.availableSubtypes = const [],
    this.availableDetails = const [],
  });

  SubscriptionState copyWith({
    String? selectedCategory,
    String? selectedSubtype,
    String? selectedDetail,
    List<String>? availableCategories,
    List<String>? availableSubtypes,
    List<String>? availableDetails,
  }) {
    return SubscriptionState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSubtype: selectedSubtype ?? this.selectedSubtype,
      selectedDetail: selectedDetail ?? this.selectedDetail,
      availableCategories: availableCategories ?? this.availableCategories,
      availableSubtypes: availableSubtypes ?? this.availableSubtypes,
      availableDetails: availableDetails ?? this.availableDetails,
    );
  }

  SubscriptionState clearSelectionAfter(int level) {
    switch (level) {
      case 1:
        return copyWith(
          selectedCategory: null,
          selectedSubtype: null,
          selectedDetail: null,
          availableSubtypes: [],
          availableDetails: [],
        );
      case 2:
        return copyWith(
          selectedSubtype: null,
          selectedDetail: null,
          availableDetails: [],
        );
      case 3:
        return copyWith(
          selectedDetail: null,
        );
      default:
        return this;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionState &&
          runtimeType == other.runtimeType &&
          selectedCategory == other.selectedCategory &&
          selectedSubtype == other.selectedSubtype &&
          selectedDetail == other.selectedDetail &&
          listEquals(availableCategories, other.availableCategories) &&
          listEquals(availableSubtypes, other.availableSubtypes) &&
          listEquals(availableDetails, other.availableDetails);

  @override
  int get hashCode =>
      selectedCategory.hashCode ^
      selectedSubtype.hashCode ^
      selectedDetail.hashCode ^
      availableCategories.hashCode ^
      availableSubtypes.hashCode ^
      availableDetails.hashCode;
}
