import 'package:flutter/material.dart';
import 'package:recasa/utils/app_styles.dart';
import 'app_colors.dart';

class AppExtras {
  static void showToast(
      {required BuildContext context,
      required String message,
      Color? bgColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppStyles.snackbarStyle,
        ),
        backgroundColor: bgColor ?? AppColors.primaryColor,
        margin: const EdgeInsets.all(8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}