import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:token_app/controllers/dashboard_controller.dart';
import 'package:token_app/utils/constants.dart';
import 'package:token_app/widgets/custom_button.dart';

import '../models/category_data.dart';

class Dashboard extends StatelessWidget {
  final controller = Get.put(DashboardController());
  Dashboard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Generate new token',
          style: TextStyle(
            color: Constants.primaryTextColor,
          ),
        ),
        backgroundColor: Constants.primaryColor,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  controller.logout();
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => LoadingOverlay(
          isLoading: controller.loading.value,
          opacity: 1.0,
          color: Constants.primaryTextColor,
          progressIndicator: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                Constants.primaryColor,
              ),
            ),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Please select the category',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ...List.generate(
                controller.length.value,
                (index) {
                  Datum category = controller.data.value!.data![index];
                  return CustomButton(
                    label: category.categoryType!,
                    buttonColor: Constants.primaryTextColor,
                    onTap: () {
                      controller.category.value = category;
                      controller.getToken(category.id.toString());
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Token Number',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                controller.tokenNumber.value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomButton(
                  label: 'Generate',
                  width: MediaQuery.of(context).size.width * 0.3,
                  buttonColor: Constants.primaryColor,
                  onTap: () {
                    if (controller.category.value != null) {
                      controller.generateToken(
                        controller.category.value!.id.toString(),
                        controller.category.value!.categoryType!,
                      );
                    } else {
                      Get.rawSnackbar(
                        message: 'Please select a category first!',
                      );
                    }
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (BuildContext context) {
                    //       return const Print();
                    //     },
                    //   ),
                    // );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
