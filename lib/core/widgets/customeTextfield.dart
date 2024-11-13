import 'package:flutter/material.dart';
import 'package:inco/core/constent/colors.dart';

class CustomeTextfield extends StatelessWidget {
  const CustomeTextfield(
      {super.key,
      this.label,
      this.validator,
      this.controller,
      this.prifixicon,
      this.suffixicon,
      this.obsecure,
      this.keybordType, this.pretext});
  final label;
  final validator;
  final controller;
  final prifixicon;
  final suffixicon;
  final obsecure;
  final keybordType;
  final pretext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        obscureText: obsecure ?? false,
        controller: controller,
        validator: validator,
        keyboardType: keybordType ?? TextInputType.text,
        decoration: InputDecoration(
          prefixText: pretext ?? '',
          prefixIcon: Icon(prifixicon),
          suffixIcon: suffixicon,
          label: Text(label),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: appThemeColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: appThemeColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: appThemeColor)),
        ),
      ),
    );
  }
}
