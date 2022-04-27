import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:token_app/models/user_data.dart';
import 'package:token_app/screens/dashboard.dart';
import 'package:token_app/screens/login.dart';

class SplashController extends GetxController {
  final GetStorage _box = GetStorage();
  @override
  void onInit() {
    Future.delayed(Duration(milliseconds: 1000), () {
      if (_box.hasData('user')) {
        String user = _box.read('user');
        UserData userData = UserData.fromMap(jsonDecode(user));
        Get.offAll(() => Dashboard());
      } else {
        Get.offAll(() => Login());
      }
    });
    super.onInit();
  }
}
