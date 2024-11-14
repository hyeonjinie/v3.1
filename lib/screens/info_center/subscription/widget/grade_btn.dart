import 'package:flutter/material.dart';

class GradeButtonWidget extends StatefulWidget {
  final Function(String) onGradeChanged; 
  final List<String> btnNames; 
  final String selectedBtn; 

  const GradeButtonWidget({
    Key? key,
    required this.onGradeChanged,
    required this.btnNames, 
    required this.selectedBtn, 
  }) : super(key: key);

  @override
  _GradeButtonWidgetState createState() => _GradeButtonWidgetState();
}

class _GradeButtonWidgetState extends State<GradeButtonWidget> {
  late String selectedBtn; 

  @override
  void initState() {
    super.initState();
    selectedBtn = widget.selectedBtn; 
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( 
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, 
        children: widget.btnNames.map((grade) {
          final isSelected = selectedBtn == grade;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedBtn = grade; 
                });
                widget.onGradeChanged(grade); 
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(60, 35),
                padding: EdgeInsets.zero,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(
                    color: isSelected ? const Color(0xFF0084FF) : const Color(0xFFE1E1E1),
                    width: isSelected ? 2.0 : 1.0,
                  ),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  grade,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF0084FF) : const Color(0xFF9CA1AB),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
