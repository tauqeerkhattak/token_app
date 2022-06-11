import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:token_app/controllers/dashboard_controller.dart';
import 'package:token_app/utils/constants.dart';
import 'package:token_app/widgets/custom_button.dart';

import '../models/category_data.dart';

class Dashboard extends StatefulWidget {
  final CategoryData? categoryData;

  const Dashboard({
    required this.categoryData,
    Key? key,
  }) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final controller = Get.put(DashboardController());
  int? val;

  initState() {
    controller.setLength(widget.categoryData!.data!.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Get new token',
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
                  'Please select a category',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                    controller.length.value,
                    (index) {
                      Datum category = widget.categoryData!.data![index];
                      return CustomButton(
                        label: category.categoryType!,
                        buttonColor: val == index
                            ? Constants.primaryColor
                            : Constants.primaryTextColor,
                        textColor: val == index ? Colors.white : Colors.black,
                        textSize: 20,
                        height: 56,
                        showBorder: true,
                        radius: 15,
                        onTap: () async {
                          val = index;

                          controller.category.value = category;
                          await controller.getToken(category.id.toString());
                          print(category.toMap().toString());
                          await controller.generateToken(
                            controller.category.value!.id.toString(),
                            controller.category.value!.categoryType!,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
