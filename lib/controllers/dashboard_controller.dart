import 'dart:developer';
import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:token_app/models/category_data.dart';
import 'package:token_app/screens/dashboard.dart';
import 'package:token_app/screens/login.dart';
import 'package:token_app/utils/services.dart';

class DashboardController extends GetxController {
  Rx<bool> loading = false.obs;
  Rx<int> length = 0.obs;
  Rx<String> tokenNumber = '__'.obs;
  Rxn<Datum> category = Rxn<Datum>();

  //Printing
  final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  String? pathImage;

  @override
  void onInit() async {
    await initSaveToPath();
    super.onInit();
  }

  void setLength(int len) {
    length.value = len;
  }

  Future<void> getToken(String categoryId) async {
    loading.value = true;
    String token = await Services.getTokenNumber(categoryId);
    if (token != 'null') {
      tokenNumber.value = token;
      log('Token: $tokenNumber');
    }
    loading.value = false;
  }

  void logout() {
    Services.logout().then(
      (value) {
        Get.offAll(
          () => Login(),
        );
      },
    );
  }

  Future<void> generateToken(String categoryId, String categoryName) async {
    loading.value = true;
    var data = await Services.generateToken(
      categoryId: category.value!.id.toString(),
      tokenNumber: tokenNumber.value,
    );
    log(data.toString());
    if (data['status'] == 'success') {
      log('Success: $tokenNumber generated');
      await print();
    }
    loading.value = false;
  }

  void showToast(String title) {
    Get.rawSnackbar(
      message: title,
    );
  }

  initSaveToPath() async {
    //read and write
    //image max 300px X 300px
    String filename = 'logo_aeg';
    var bytes = await rootBundle.load('assets/images/logo.jpg');
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes, '$dir/$filename');
    pathImage = '$dir/$filename';
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<void> print() async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT
    DateTime now = DateTime.now();
    DateFormat format = DateFormat('dd-MM-yyyy hh:mm a');
    String date = 'Dated: ${format.format(now)}';
    bluetooth.isConnected.then((isConnected) async {
      if (isConnected!) {
        await bluetooth.printNewLine();
        await bluetooth.printImage(
          pathImage!,
        );
        await bluetooth.printNewLine();
        await bluetooth.printCustom(date, 1, 1);
        await bluetooth.printCustom('_________________________________', 3, 1);
        await bluetooth.printNewLine();
        await bluetooth.printCustom(category.value!.categoryType!, 1, 1);
        await bluetooth.printNewLine();
        await bluetooth.printCustom('Token Number', 1, 1);
        await bluetooth.printNewLine();
        await bluetooth.printCustom(tokenNumber.value, 4, 1);
        await bluetooth.printCustom('_________________________________', 3, 1);
        await bluetooth.printNewLine();
        await bluetooth.printCustom(
            'If your token number passes, please get a new token.', 0, 1);
        await bluetooth.printNewLine();
        await bluetooth.paperCut();
        CategoryData? data = await Services.getCategories();
        Get.offAll(
          () => Dashboard(
            categoryData: data,
          ),
        );
      }
    });
  }
}
