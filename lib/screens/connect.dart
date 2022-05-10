import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:token_app/controllers/connect_controller.dart';
import 'package:token_app/utils/constants.dart';
import 'package:token_app/widgets/custom_button.dart';

class Connect extends StatelessWidget {
  final controller = Get.put(ConnectController());
  Connect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect to a Printer'),
        centerTitle: true,
        backgroundColor: Constants.primaryColor,
      ),
      body: Obx(
        () => SizedBox(
          width: double.maxFinite,
          child: LoadingOverlay(
            isLoading: controller.loading.value,
            progressIndicator: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  Constants.primaryColor,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Select a bluetooth device: '),
                DropdownButton<BluetoothDevice>(
                  value: controller.device.value,
                  items: controller.devices.value.map(
                    (e) {
                      return DropdownMenuItem<BluetoothDevice>(
                        child: Text(e.name!),
                        value: e,
                      );
                    },
                  ).toList(),
                  onChanged: (BluetoothDevice? value) {
                    controller.device.value = value;
                  },
                ),
                CustomButton(
                  label: 'Connect',
                  onTap: () => controller.connect(),
                  buttonColor: Constants.primaryColor,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
