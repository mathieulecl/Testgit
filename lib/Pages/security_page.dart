import 'package:flutter/material.dart';

class SecurityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800], // Dark gray background
      appBar: AppBar(
        title: Text('Security Page'),
        backgroundColor: Colors.grey[900], // Darker gray app bar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'This is a secure page.\nYour data is protected.',
            style: TextStyle(
              color: Colors.white, // Text color
              fontSize: 18.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: SecurityPage(),
    ),
  );
}
