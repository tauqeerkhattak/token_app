import 'package:flutter/material.dart';
import 'package:token_app/utils/constants.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Function() onTap;
  const CustomButton({Key? key, required this.label, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 10,),
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.06,
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: Constants.primaryTextColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Constants.primaryColor,),
        ),
      ),
    );
  }
}
