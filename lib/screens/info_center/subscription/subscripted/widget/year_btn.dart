import 'package:flutter/material.dart';

class YearButtonWidget extends StatefulWidget {
  final List<String> availableYears;
  final List<String> selectedYears;
  final void Function(List<String>) onYearsChanged;
  final Map<String, Color> yearColorMap;

  YearButtonWidget({
    required this.availableYears,
    required this.selectedYears,
    required this.onYearsChanged,
    required this.yearColorMap,
  });

  @override
  _YearButtonWidgetState createState() => _YearButtonWidgetState();
}

class _YearButtonWidgetState extends State<YearButtonWidget> {
  @override
  Widget build(BuildContext context) {
    double btnWidth;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: widget.availableYears.map((year) {
          final isSelected = widget.selectedYears.contains(year);
          final yearColor =
              widget.yearColorMap[year] ?? const Color(0xFFE1E1E1);
          btnWidth = 70;

          return Padding(
            padding:
                EdgeInsets.all(5.0),
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (isSelected) {
                      widget.selectedYears.remove(year);
                    } else {
                      widget.selectedYears.add(year);
                    }
                    widget.onYearsChanged(widget.selectedYears);
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(btnWidth, 35),
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                      color: isSelected ? yearColor : const Color(0xFFE1E1E1),
                      width: isSelected ? 2.0 : 1.0,
                    ),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    year,
                    style: TextStyle(
                      color: isSelected ? yearColor : const Color(0xFF9CA1AB),
                    ),
                  ),
                )),
          );
        }).toList(),
      ),
    );
  }
}
