import 'package:flutter/material.dart';

import '../../../../../../widgets/responsive_safe_area/responsive_safe_area.dart';

class CategoryDurationSelector extends StatelessWidget {
  final String currentCategory;
  final int currentDuration;
  final Function(String) onCategorySelected;
  final Function(int) onDurationSelected;

  CategoryDurationSelector({
    required this.currentCategory,
    required this.currentDuration,
    required this.onCategorySelected,
    required this.onDurationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['특', '상', '중', '하'].map((category) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextButton(
                        onPressed: () {
                          onCategorySelected(category);
                          onDurationSelected(365);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: currentCategory == category
                              ? const Color(0xFF56CF9D)
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(
                              color: currentCategory == category
                                  ? Colors.transparent
                                  : Colors.grey,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 8),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: currentCategory == category
                                ? Colors.white
                                : Colors.black,
                            fontWeight: currentCategory == category
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [7, 30, 90, 180, 365].map((days) {
                  String dayLabel;
                  switch (days) {
                    case 7:
                      dayLabel = '1주';
                      break;
                    case 30:
                      dayLabel = '1개월';
                      break;
                    case 90:
                      dayLabel = '3개월';
                      break;
                    case 180:
                      dayLabel = '6개월';
                      break;
                    case 365:
                      dayLabel = '1년';
                      break;
                    default:
                      dayLabel = '$days 일';
                  }
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextButton(
                        onPressed: () => onDurationSelected(days),
                        style: TextButton.styleFrom(
                          backgroundColor: currentDuration == days
                              ? const Color(0xFF56CF9D)
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(
                              color: currentDuration == days
                                  ? Colors.transparent
                                  : Colors.grey, // Add this line
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                        ),
                        child: Text(
                          dayLabel,
                          style: TextStyle(
                            color: currentDuration == days
                                ? Colors.white
                                : Colors.black,
                            fontWeight: currentDuration == days
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
