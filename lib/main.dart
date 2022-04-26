import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:token_app/screens/splash.dart';

void main() async {
  await GetStorage.init();
  runApp(const TokenApp());
}

class TokenApp extends StatelessWidget {
  const TokenApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Token App',
      home: Splash(),
    );
  }
}
