import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:token_app/controllers/dashboard_controller.dart';
import 'package:token_app/models/user_data.dart';
import 'package:token_app/utils/constants.dart';
import 'package:token_app/widgets/custom_button.dart';

import '../models/category_data.dart';

class Dashboard extends StatelessWidget {
  final UserData userData;
  final controller = Get.put(DashboardController());
  Dashboard({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: Constants.primaryTextColor,
          ),
        ),
        backgroundColor: Constants.primaryColor,
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...List.generate(
                controller.length.value,
                (index) {
                  Datum category = controller.data.value!.data![index];
                  return CustomButton(
                    label: category.categoryType!,
                    onTap: () {},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
