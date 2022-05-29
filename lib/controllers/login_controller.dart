import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:token_app/models/user_data.dart';
import 'package:token_app/screens/connect.dart';
import 'package:token_app/screens/dashboard.dart';
import 'package:token_app/utils/constants.dart';
import 'package:token_app/utils/services.dart';

class LoginController extends GetxController {
  Rx<bool> loading = false.obs;
  final key = GlobalKey<FormState>();
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  TextEditingController email =
      TextEditingController(text: Constants.dummyEmail);
  TextEditingController password =
      TextEditingController(text: Constants.dummyPassword);
  TextEditingController baseUrl =
      TextEditingController(text: Constants.baseUrl);

  void login() async {
    if (key.currentState!.validate()) {
      loading.value = true;
      UserData? data =
          await Services.login(email: email.text, password: password.text);
      if (data != null) {
        loading.value = false;
        printer.isConnected.then((value) {
          if (value!) {
            Get.offAll(() => Dashboard());
          } else {
           Get.offAll(() => Connect());
            // Get.offAll(() => Dashboard());
          }
        });
      }
    }
  }
}
