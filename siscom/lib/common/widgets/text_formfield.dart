import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validate;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final Widget? prefixIcon;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Function(String?)? onChange;
  final TextInputType? textInputType;
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.validate,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.prefixIcon,
    this.suffixIcon,
    this.onChange,
    this.textInputType,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          keyboardType: textInputType,
          validator: validate,
          obscureText: obscureText ?? false,
          controller: controller,
          onChanged: onChange,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              hintText: hintText,
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.grey),
              )),
        ),
      ],
    );
  }
}
