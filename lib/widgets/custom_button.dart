import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Function() onTap;
  final Color buttonColor;
  final double? width;
  final double? textSize;
  final double? height;
  final double? radius;
  final Color textColor;
  final bool? showBorder;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onTap,
    required this.buttonColor,
    this.width,
    required this.textColor,
    this.textSize,
    this.height,
    this.radius,
    this.showBorder = false,
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
      height: height ?? MediaQuery.of(context).size.height * 0.06,
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: textColor,
            fontSize: textSize ?? 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            buttonColor,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 10),
              side: showBorder!
                  ? BorderSide(
                      color: Colors.grey.shade300,
                      width: 2,
                    )
                  : BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
