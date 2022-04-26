import 'package:flutter/material.dart';
import 'package:token_app/screens/login.dart';

void main() {
  runApp(const TokenApp());
}

class TokenApp extends StatelessWidget {
  const TokenApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Token App',
      home: Login(),
    );
  }
}
