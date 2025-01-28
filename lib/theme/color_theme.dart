import 'package:flutter/material.dart';

class AppColors {
  static const LinearGradient background = LinearGradient(
    colors: [
      Color(0xFFCAF0FF),
      Colors.white,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  //Card
  static const Color cardPrimary = const Color(0xff01FFb3);
  static const Color cardSecondary = const Color(0xffFFeb3b);

  //Button
  static const Color buttonPrimary = const Color(0xffa421d9);
  static const Color buttonSecondary = const Color(0xfff3c84b);
  static const Color buttonDisabled = const Color(0xffd9d9d9);

  //Icon
  static const Color iconPrimary = Color(0xffa421d9);
  static const Color iconPrimaryVariant = Color(0xff015486);
  static const Color iconOnPrimary = Color(0xffffffff);
  static const Color iconSecondary = Colors.white;
  static const Color iconDisabled = Color(0xff848484);

  //Text
  static const Color textPrimary = Color(0xff015486);
  static const Color textOnPrimary = Colors.white;
  static const Color textSecondary = const Color(0xff676666);
  static const Color textHighlighted = const Color(0xffa421d9);

  //Notification
  static const Color notificationPositive = const Color(0xff81c784);
  static const Color notificationWarning = const Color(0xffff9800);
  static const Color notificationCritical = const Color(0xffe57373);

  static const Color progressBar = const Color(0xffeed3f8);
  static const Color strokeColor = const Color(0xffa2a2a2);
  static const Color inputFieldBG = const Color(0xfff6f6f6);
  static const Color currencyStroke = const Color(0xff4caf50);
  static const Color critical = const Color(0xffff6757);
  static const Color KidZoneParent = const Color(0xff38BEBE);
  static const Color primaryLightColor = const Color(0xFFD2A4EF);
}
