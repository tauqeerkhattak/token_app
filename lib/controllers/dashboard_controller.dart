import 'dart:developer';
import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:token_app/models/category_data.dart';
import 'package:token_app/screens/login.dart';
import 'package:token_app/utils/constants.dart';
import 'package:token_app/utils/services.dart';

class DashboardController extends GetxController {
  Rx<bool> loading = false.obs;
  Rx<int> length = 0.obs;
  Rx<String> tokenNumber = '__'.obs;
  Rxn<Datum> category = Rxn<Datum>();
  Rx<CategoryData?> data = CategoryData().obs;

  //Printing
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  Rx<List<BluetoothDevice>> devices = Rx<List<BluetoothDevice>>([]);
  Rxn<BluetoothDevice> device = Rxn<BluetoothDevice>();
  Rx<bool> connected = false.obs;
  String? pathImage;

  Future<void> initPlatformState() async {
    List<BluetoothDevice> temp = [];

    try {
      temp = await bluetooth.getBondedDevices();
    } on PlatformException {
      log('Error while getting bluetooth devices');
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          connected.value = true;
          break;
        case BlueThermalPrinter.DISCONNECTED:
          connected.value = false;
          break;
        default:
          log(state.toString());
          break;
      }
    });
    devices.value = temp;
  }

  @override
  void onInit() async {
    loading.value = true;
    data.value = await Services.getCategories();
    length.value = data.value!.data!.length;
    loading.value = false;
    await initPlatformState();
    await initSaveToPath();
    super.onInit();
  }

  @override
  void dispose() {
    bluetooth.disconnect();
    super.dispose();
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
    Services.logout().then(
      (value) {
        Get.offAll(
          () => Login(),
        );
      },
    );
  }

  void generateToken(String categoryId, String categoryName) async {
    loading.value = true;
    if (!connected.value) {
      showDialog();
    } else {
      log('Here');
      _connect();
    }
    loading.value = false;
  }

  void _connect() {
    if (device.value == null) {
      showToast('No device selected.');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected!) {
          bluetooth.connect(device.value!).then((value) {
            print();
          }).catchError((error) {
            Get.rawSnackbar(message: 'Error: $error');
          });
        }
      });
    }
  }

  void showDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Connect to Printer'),
        content: SizedBox(
          height: 150,
          width: double.maxFinite,
          child: Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Select a bluetooth device: '),
                Obx(
                  () => DropdownButton<BluetoothDevice>(
                    value: device.value,
                    items: devices.value.map(
                      (e) {
                        return DropdownMenuItem<BluetoothDevice>(
                          child: Text(e.name!),
                          value: e,
                        );
                      },
                    ).toList(),
                    onChanged: (BluetoothDevice? value) {
                      device.value = value;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: Text(
              'Connect',
              style: TextStyle(
                color: Constants.primaryColor,
              ),
            ),
            onPressed: () {
              _connect();
            },
          ),
        ],
      ),
    );
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
    var bytes = await rootBundle.load('assets/images/logo.png');
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes, '$dir/$filename');
    pathImage = '$dir/$filename';
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  void print() async {
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
        await bluetooth.printImage(pathImage!);
        await bluetooth.printNewLine();
        await bluetooth.printCustom(date, 2, 1);
        await bluetooth.printNewLine();
        await bluetooth.printCustom('_______________________', 1, 1);
        await bluetooth.printNewLine();
        await bluetooth.printCustom(category.value!.categoryType!, 2, 1);
        await bluetooth.printNewLine();
        await bluetooth.printCustom('Token Number', 2, 1);
        await bluetooth.printNewLine();
        await bluetooth.printCustom(tokenNumber.value, 3, 1);
        await bluetooth.printNewLine();
        await bluetooth.printCustom('_______________________', 1, 1);
        await bluetooth.printNewLine();
        await bluetooth.printCustom('Space for other text', 2, 1);
        await bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.paperCut();
      }
    });
  }
}
