import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agriculture App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Agriculture Data'),
        ),
        body: Center(
          child: Text('Welcome to Agriculture App'),
        ),
      ),
    );
  }
}
