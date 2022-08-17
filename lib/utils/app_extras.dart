import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recasa/utils/app_styles.dart';
import 'app_colors.dart';

class AppExtras {
  static void showToast({
    required BuildContext context,
    required String message,
    Color? bgColor,
    double? width,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppStyles.snackbarStyle,
        ),
        width: width,
        backgroundColor: bgColor ?? AppColors.primaryColor,
        margin: const EdgeInsets.all(8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void push(BuildContext context, Widget child) {
    Navigator.of(context).push(
      CupertinoPageRoute(builder: (context) => child),
    );
  }

  static void replace(BuildContext context, Widget child) {
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(builder: (context) => child),
    );
  }
}
