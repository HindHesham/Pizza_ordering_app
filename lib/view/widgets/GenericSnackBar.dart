import 'package:flutter/material.dart';

class GenericSnackBar {
  GenericSnackBar();

  static buildErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$message"),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }
}
