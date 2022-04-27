import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:token_app/models/category_data.dart';
import 'package:token_app/screens/dashboard.dart';
import 'package:token_app/screens/login.dart';
import 'package:token_app/utils/services.dart';

class DashboardController extends GetxController {
  Rx<bool> loading = false.obs;
  Rx<int> length = 0.obs;
  Rx<String> tokenNumber = '__'.obs;
  Rx<Datum> category = Datum().obs;
  Rx<CategoryData?> data = CategoryData().obs;

  @override
  void onInit() async {
    loading.value = true;
    data.value = await Services.getCategories();
    length.value = data.value!.data!.length;
    loading.value = false;
    super.onInit();
  }

  void getToken(String categoryId) async {
    loading.value = true;
    String token = await Services.getTokenNumber(categoryId);
    if (token != 'null') {
      tokenNumber.value = token;
    }
    loading.value = false;
  }

  void logout() {
    Services.logout().then((value) {
      Get.offAll(() => Login());
    });
  }

  void generateToken(String categoryId) async {
    loading.value = true;
    var data = await Services.generateToken(
        categoryId: categoryId, tokenNumber: tokenNumber.value);
    Get.dialog(
      AlertDialog(
        title: Text(data['status']),
        content: Text(data['message']),
        actions: [
          TextButton(
            onPressed: () {
              if (data['status'] == 'error') {
                Get.back();
              } else if (data['status'] == 'success') {
                Get.offAll(() => Dashboard());
              }
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
    loading.value = false;
  }
}
