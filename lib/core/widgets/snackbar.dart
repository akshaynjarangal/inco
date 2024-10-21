import 'package:flutter/material.dart';

void snackbarWidget(context, data, color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      data,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
  ));
}
