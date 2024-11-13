import 'package:flutter/material.dart';

class Banner1 extends StatelessWidget {
  final int bannerIndex;

  const Banner1({Key? key, required this.bannerIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page for Banner $bannerIndex'),
      ),
      body: Center(
        child: Text('Showing details for banner $bannerIndex'),
      ),
    );
  }
}
