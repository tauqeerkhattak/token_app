import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:token_app/controllers/splash_controller.dart';

class Splash extends StatelessWidget {
  final controller = Get.put(SplashController());
  Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/Welcome.png',),fit: BoxFit.fill)),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //
        //   children: [
        //    // AssetImage(),
        //
        //     // CircularProgressIndicator(
        //     //   valueColor: AlwaysStoppedAnimation(
        //     //     Constants.primaryColor,
        //     //   ),
        //     // ),
        //   ],
        // ),
      ),
    );
  }
}