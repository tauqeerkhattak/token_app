import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:token_app/models/category_data.dart';
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
  final GetStorage _getStorage = GetStorage();

  void login() async {
    if (key.currentState!.validate()) {
      loading.value = true;
      UserData? data =
          await Services.login(email: email.text, password: password.text);
      if (data != null) {
        await _getStorage.write('email', email.text);
        loading.value = false;
        printer.isConnected.then((value) async {
          if (value!) {
            CategoryData? data = await Services.getCategories();
            Get.offAll(
              () => Dashboard(
                categoryData: data,
              ),
            );
          } else {
            Get.offAll(() => Connect());
          }
        });
      }
    }
  }
}
