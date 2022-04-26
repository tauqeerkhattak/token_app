import 'package:get/get.dart';
import 'package:token_app/models/category_data.dart';
import 'package:token_app/utils/services.dart';

class DashboardController extends GetxController {
  Rx<bool> loading = false.obs;
  Rx<int> length = 0.obs;
  Rx<CategoryData?> data = CategoryData().obs;
  @override
  void onInit() async {
    loading.value = true;
    data.value = await Services.getCategories();
    length.value = data.value!.data!.length;
    loading.value = false;
    super.onInit();
  }
}