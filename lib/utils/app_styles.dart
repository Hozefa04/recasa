import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recasa/utils/app_colors.dart';

class AppStyles {
  static TextStyle headingStyleBold = GoogleFonts.openSans(
    color: Colors.white70,
    fontWeight: FontWeight.bold,
    fontSize: 32,
  );

  static TextStyle appBarStyle = GoogleFonts.openSans(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 26,
  );

  static TextStyle mediumTextStyleBold = GoogleFonts.openSans(
    color: Colors.white70,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );

  static TextStyle smallTextStyleBold = GoogleFonts.openSans(
    color: Colors.white70,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  static TextStyle linkTextStyleBold = GoogleFonts.openSans(
    color: AppColors.secondaryColor,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static TextStyle buttonTextStyle = GoogleFonts.openSans(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 22,
  );

  static TextStyle snackbarStyle = GoogleFonts.openSans(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  static TextStyle errorText = GoogleFonts.openSans(
    color: Colors.redAccent,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static TextStyle nftTitleStyle = GoogleFonts.openSans(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );
}
