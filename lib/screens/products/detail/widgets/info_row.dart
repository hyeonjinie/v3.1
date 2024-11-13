import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String title;
  final String content;

  const InfoRow({Key? key, required this.title, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        width: screenWidth > 1200 ? 1200 : screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: 1,
                color: Colors.grey,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
              ),
              Expanded(
                child: Text(content),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
