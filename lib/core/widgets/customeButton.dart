import 'package:flutter/material.dart';
import 'package:inco/core/constent/colors.dart';

class CustomeButton extends StatelessWidget {
  const CustomeButton(
      {super.key,
      required this.height,
      required this.width,
      required this.text,
      this.ontap});
  final double height;
  final double width;
  final String text;
  final ontap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
              blurRadius: 1,
              spreadRadius: 1,
              color: Colors.black26,
              offset: Offset(0, 1))
        ], color: appThemeColor, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
