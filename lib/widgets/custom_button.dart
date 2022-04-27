import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Function() onTap;
  final Color buttonColor;
  final double? width;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onTap,
    required this.buttonColor,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 14,
        bottom: 14,
        left: 10,
        right: 10,
      ),
      width: width ?? MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.06,
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            //   color: Constants.primaryTextColor,
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            buttonColor,
          ),
        ),
      ),
    );
  }
}
