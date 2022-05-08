import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:token_app/screens/connect.dart';
import 'package:token_app/screens/dashboard.dart';
import 'package:token_app/screens/login.dart';

class SplashController extends GetxController {
  final GetStorage _box = GetStorage();
  final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  @override
  void onInit() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (_box.hasData('user')) {
        bluetooth.isConnected.then((value) {
          if (value!) {
            Get.offAll(() => Dashboard());
          }
          else {
            Get.offAll(() => Connect());
          }
        });
      } else {
        Get.offAll(() => Login());
      }
    });
    super.onInit();
  }
}
