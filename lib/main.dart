import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:token_app/screens/splash.dart';
import 'package:token_app/utils/constants.dart';

void main() async {
  await GetStorage.init();
  GetStorage storage = GetStorage();
  if (storage.hasData('email')) {
    Constants.dummyEmail = storage.read('email');
  }
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
