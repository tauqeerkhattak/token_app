import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:token_app/controllers/splash_controller.dart';
import 'package:token_app/utils/constants.dart';

class Splash extends StatelessWidget {
  final controller = Get.put(SplashController());
  Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(
            Constants.primaryColor,
          ),
        ),
      ),
    );
  }
}