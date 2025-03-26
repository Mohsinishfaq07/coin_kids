import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter/material.dart';

class AppColors {
  static LinearGradient background = LinearGradient(
    colors: [
      Color(0xFFCAF0FF),
      Colors.white,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient backgroundInverse = LinearGradient(
    colors: [
      Colors.white,
      Color(0xFFCAF0FF),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  //color primary
  static Color colorPrimary = Color(0xffa421d9);
  static Color colorSecondary = Color(0xFFFF9E29);

  //Card
  static Color cardPrimary = Color(0xFFEDFAFF);
  static Color cardBorder = Color(0xFFCBE4F3);
  static Color cardSecondary = Color(0xffFFeb3b);

  //Button
  static Color buttonPrimary = Color(0xffa421d9);
  static Color buttonSecondary = Color(0xfff3c84b);
  static Color buttonDisabled = Color(0xffd9d9d9);
  static Color skipButton = Color(0xFFFF9E29);

  //Icon
  static Color iconPrimary = Color(0xffa421d9);
  static Color iconPrimaryVariant = Color(0xff015486);
  static Color iconOnPrimary = Color(0xffffffff);
  static Color iconSecondaryVariant = Color(0xFFFF9E29);
  static Color iconSecondary = Colors.white;
  static Color iconDisabled = Color(0xff848484);

  //Text
  static Color textPrimary = Color(0xff015486);
  static Color textOnPrimary = Colors.white;
  static Color textSecondary = Color(0xff676666);
  static Color textHighlighted = Color(0xffa421d9);

  //Notification
  static Color notificationPositive = Color(0xff81c784);
  static Color notificationWarning = Color(0xffff9800);
  static Color notificationCritical = Color(0xffe57373);

  static Color progressBar = Color(0xffeed3f8);
  static Color strokeColor = Color(0xffa2a2a2);
  static Color inputFieldBG = Color(0xfff6f6f6);
  static Color currencyStroke = Color(0xff4caf50);
  static Color critical = Color(0xffff6757);
  static Color kidZoneParent = Color(0xff38BEBE);
  static Color primaryLightColor = Color(0xFFD2A4EF);
  static Color addIconBorderColor = Color(0xFF148F2F);

  //Kid Button Colors
  static Color btnColorGreen = Color(0xFF19B859);
  static Color btnColorOrange = Color(0xFFFF9E29);
  static Color btnColorRed = Color(0xFFF6612F);
 }
