import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:token_app/controllers/login_controller.dart';
import 'package:token_app/utils/constants.dart';
import 'package:token_app/widgets/custom_button.dart';
import 'package:token_app/widgets/custom_text_field.dart';

class Login extends StatelessWidget {
  final controller = Get.put(LoginController());
  Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
            color: Constants.primaryTextColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Constants.primaryColor,
      ),
      body: Obx(
        () => LoadingOverlay(
          isLoading: controller.loading.value,
          progressIndicator: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                Constants.primaryColor,
              ),
            ),
          ),
          child: Form(
            key: controller.key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  label: 'Email',
                  controller: controller.email,
                  prefixIcon: Icons.email,
                  validator: (String? email) {
                    if (email!.isEmpty) {
                      return 'Enter an email';
                    } else if (!email.contains('@')) {
                      return 'Enter a valid email';
                    } else if (!email.contains('.com')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  label: 'Password',
                  controller: controller.password,
                  prefixIcon: Icons.password,
                  hideText: true,
                  validator: (String? password) {
                    if (password!.isEmpty) {
                      return 'Enter a password';
                    } else if (password.length < 6) {
                      return 'Password must contains at least 6 characters';
                    }
                    return null;
                  },
                ),
                // CustomTextField(
                //   label: 'Base Url',
                //   controller: controller.baseUrl,
                //   prefixIcon: Icons.network_wifi,
                //   validator: (String? url) {
                //     if (url!.isEmpty) {
                //       return 'Enter a url';
                //     }
                //     return null;
                //   },
                // ),
                CustomButton(
                  buttonColor: Constants.primaryTextColor,
                  width: MediaQuery.of(context).size.width * 0.6,
                  label: 'Login',
                  onTap: () => controller.login(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
