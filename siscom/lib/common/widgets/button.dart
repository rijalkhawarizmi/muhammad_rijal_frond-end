import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Widget? icon;
  final bool? isLoading;
  final Color? color;
  final double? height;
  final double? widht;
  final double? borderRadius;
  final Color? colorText;

  const CustomButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.icon,
      this.color,
      this.height,
      this.widht,
      this.borderRadius,
      this.colorText,
      this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: borderRadius != null
                  ? BorderRadius.circular(borderRadius!)
                  : BorderRadius.circular(8)),
          minimumSize: height != null || widht != null
              ? Size(widht ?? 0, height ?? 0)
              : Size(double.infinity, 50)),
      onPressed: onPressed,
      child: isLoading == true
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.white30
                
              ),
            )
          :Text(text,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: colorText ?? Colors.white),)
    );
  }
}
