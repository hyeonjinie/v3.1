import 'package:flutter/material.dart';
import '../../../widgets/font_size_helper/font_size_helper.dart';

class SubcategorySelector extends StatelessWidget {
  final String category;
  final List<String> subcategories;
  final int selectedSubcategoryIndex;
  final ValueChanged<int> onSubcategorySelected;

  const SubcategorySelector({
    Key? key,
    required this.category,
    required this.subcategories,
    required this.selectedSubcategoryIndex,
    required this.onSubcategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 60,
      color: const Color(0xFFDEE6FF),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: subcategories.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedSubcategoryIndex == index;
          return GestureDetector(
            onTap: () => onSubcategorySelected(index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF11C278) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color:
                  isSelected ? Colors.transparent : const Color(0xFFDEE6FF),
                ),
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    subcategories[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: getFontSize(context, FontSizeType.medium),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
