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
               onTap: (){},
                 child: Text('Logout',style: TextStyle(fontSize: 17),)),
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
//            mainAxisAlignment: MainAxisAlignment.center,
          //  crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ...List.generate(
              //   controller.length.value,
              //   (index) {
              //     Datum category = controller.data.value!.data![index];
              //     return CustomButton(
              //       label: category.categoryType!,
              //       onTap: () {},
              //     );
              //   },
              // ),

        Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Please select the cateory',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ),
              ...List.generate(
                controller.length.value,
                (index) {
                  Datum category = controller.data.value!.data![index];
                  return CustomButton(

                    label: category.categoryType!,
                    onTap: () {

                    },
                  );
                },
              ),
              SizedBox(height: 20,),

              Text('Token Number',textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,),),

              SizedBox(height: 20,),
              
              Text('__',textAlign: TextAlign.center, style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,),),

Spacer(),
Align(
  alignment: Alignment.bottomLeft,
  child:   Container(
    margin:const EdgeInsets.all(10),
    child: ElevatedButton(onPressed: (){}, child:const Text('Generate',style: TextStyle(fontWeight: FontWeight.bold,),),
      style: ElevatedButton.styleFrom(
        primary: Colors.orange,
        minimumSize: const Size(100, 50),
        maximumSize: const Size(100, 50),
      ),
    ),
  ),
),
            ],
          ),
        ),
      ),



    );
  }
}
