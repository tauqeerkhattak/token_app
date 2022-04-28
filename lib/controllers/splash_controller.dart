import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:token_app/screens/dashboard.dart';
import 'package:token_app/screens/login.dart';

class SplashController extends GetxController {
  final GetStorage _box = GetStorage();
  @override
  void onInit() {
    Future.delayed(Duration(milliseconds: 3000), () {
      if (_box.hasData('user')) {
        Get.offAll(() => Dashboard());
      } else {
        Get.offAll(() => Login());
      }
    });
    super.onInit();
  }
}
