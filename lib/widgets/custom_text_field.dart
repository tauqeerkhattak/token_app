import 'package:flutter/material.dart';
import 'package:token_app/utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData prefixIcon;
  final String? Function (String?) validator;
  final bool? hideText;
  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    required this.prefixIcon, required this.validator, this.hideText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      child: TextFormField(
        decoration: InputDecoration(
          label: Text(label),
          labelStyle: TextStyle(
            color: Constants.primaryColor,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Constants.primaryColor,
            ),
            borderRadius: BorderRadius.circular(
              15,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Constants.primaryColor,
            ),
            borderRadius: BorderRadius.circular(
              15,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Constants.primaryColor,
            ),
            borderRadius: BorderRadius.circular(
              15,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Constants.primaryColor,
            ),
            borderRadius: BorderRadius.circular(
              15,
            ),
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: Constants.primaryColor,
          ),
        ),
        obscureText: hideText ?? false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        controller: controller,
      ),
    );
  }
}
