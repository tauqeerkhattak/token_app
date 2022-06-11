import 'dart:developer';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:get/get.dart';
import 'package:token_app/models/category_data.dart';
import 'package:token_app/screens/dashboard.dart';
import 'package:token_app/utils/services.dart';

class ConnectController extends GetxController {
  final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  Rx<bool> loading = false.obs;
  Rxn<BluetoothDevice> device = Rxn<BluetoothDevice>();
  Rx<List<BluetoothDevice>> devices = Rx<List<BluetoothDevice>>([]);

  @override
  void onInit() {
    getDevices();
    super.onInit();
  }

  Future<void> getDevices() async {
    List<BluetoothDevice> temp = await bluetooth.getBondedDevices();
    if (temp.isNotEmpty) {
      devices.value = temp;
    }
  }

  @override
  void dispose() {
    bluetooth.disconnect();
    super.dispose();
  }

  void connect() {
    if (device.value != null) {
      loading.value = true;
      log('Device is selected');
      bluetooth.isConnected.then((value) {
        if (!value!) {
          bluetooth.connect(device.value!).then((value) async {
            CategoryData? data = await Services.getCategories();
            Get.offAll(
              () => Dashboard(
                categoryData: data,
              ),
            );
          }).catchError((onError) {
            loading.value = false;
            Get.rawSnackbar(message: 'Error: $onError');
          });
        } else {
          loading.value = false;
          log('Bluetooth is not connected!');
        }
      });
    } else {
      Get.rawSnackbar(
        message: 'Please select a device!',
      );
    }
  }
}
