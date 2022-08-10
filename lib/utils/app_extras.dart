import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppExtras {
  static void showToast({ required BuildContext context, required String message, Color? bgColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor ?? AppColors.primaryColor,
        margin: const EdgeInsets.all(8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
